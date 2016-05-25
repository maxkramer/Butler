//
//  SendRequestViewController.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import RealmSwift

class SendRequestViewController: UITableViewController, UITextFieldDelegate {
    
    var workingRequest = Request()
    var tableViewDatasource: SendRequestTableViewDatasource!
    var urlTextField: SemiBorderedTextField!
    var requestMethods = RequestMethod.allMethods()
    var bodyFormats = BodyFormat.allFormats()
    
    var runningDataTask: NSURLSessionDataTask?
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        configureTableView()
        configureTextField()
        
        let tableHeader = generateTableHeaderView()
        tableView.tableHeaderView = tableHeader.headerView
        
        let tableFooter = generateTableFooterView()
        tableView.tableFooterView = tableFooter.footerView
        
        NSLayoutConstraint.activateConstraints(tableHeader.constraints + tableFooter.constraints)
        
        let sendRequestButton = UIBarButtonItem(title: "Send", style: .Plain, target: self, action: #selector(sendRequest))
        navigationItem.rightBarButtonItem = sendRequestButton
        super.viewDidLoad()
    }
    
    func sendRequest() {
        let request = tableViewDatasource.generateRequest()
        request.rawBodyFormat = workingRequest.rawBodyFormat
        request.url = workingRequest.url
        request.rawRequestMethod = workingRequest.rawRequestMethod
        // perform validation
        
        print(request)
        
        let url = NSURL(string: request.url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        print("got url => \(url)")
        
        let validURL = url != nil
        
        guard validURL else {
            urlTextField.borderColor = UIColor.redColor()
            return
        }
        
        urlTextField.borderColor = R.color.butlerColors.gray()
        
        // create request
        
        let urlRequest = NSURLRequest.requestFrom(request)
        print("url => \(urlRequest?.URL)")
        if let data = urlRequest?.HTTPBody {
            print("data => \(String(data: data, encoding: NSASCIIStringEncoding))")
        }
        print("method => \(urlRequest?.HTTPMethod)")
        print("headers => \(urlRequest?.allHTTPHeaderFields)")
        
        if let runningDataTask = runningDataTask where runningDataTask.state != .Running {
            runningDataTask.cancel()
        }
        
        ProgressAlertView.show()
        
        runningDataTask = GlobalURLSession.sharedSession.urlSession.dataTaskWithRequest(urlRequest!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                ProgressAlertView.hide()
                if let error = error {
                    //                    SCLAlertView().showError(error.domain, subTitle: error.localizedDescription)
                } else if let data = data {
                    if let responseString = String(data: data, encoding: NSASCIIStringEncoding) {
                        print("data(ASCII) => \(responseString))")
                    }
                    else if let responseString = String(data: data, encoding: NSUTF8StringEncoding) {
                        print("data(UTF8) => \(responseString)")
                    }
                    else {
                        
                    }
                }
            }
        }
        runningDataTask!.resume()
    }
    
    // MARK: Setup the table view
    
    func configureTableView() {
        tableViewDatasource = SendRequestTableViewDatasource(self.tableView)
        tableView.dataSource = tableViewDatasource
        tableView.delegate = tableViewDatasource
        tableView.keyboardDismissMode = .OnDrag
        tableView.backgroundView = UIImageView(image: R.image.sendRequestBackground())
    }
    
    // MARK: Setup the URL text field
    
    func configureTextField() {
        urlTextField = SemiBorderedTextField(frame: CGRect.zero)
        urlTextField.inset = 10
        urlTextField.borderColor = R.color.butlerColors.gray()
        urlTextField.borderStyle = .None
        urlTextField.autocorrectionType = .No
        urlTextField.autocapitalizationType = .None
        urlTextField.keyboardType = .URL
        urlTextField.returnKeyType = .Done
        urlTextField.attributedPlaceholder = NSAttributedString(string: "URL", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.8)])
        urlTextField.textColor = R.color.butlerColors.lightText()
        urlTextField.font = R.font.gothamHTFLight(size: 15)
        urlTextField.delegate = self
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        urlTextField.textAlignment = NSTextAlignment.Center
    }
    
    // MARK: Create the table header view
    
    func generateTableHeaderView() -> (headerView: UIView, constraints: [NSLayoutConstraint]) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110))
        
        containerView.addSubview(urlTextField)
        
        let topSlider = MultipleButtonSlider.butlerSlider(RequestMethod.allMethods().map { return $0.rawValue }, callback: requestMethodSliderCallback)
        topSlider.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(topSlider)
        
        let constraints: [NSLayoutConstraint] = [
            urlTextField.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 20),
            urlTextField.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -20),
            urlTextField.heightAnchor.constraintEqualToConstant(40),
            topSlider.topAnchor.constraintEqualToAnchor(urlTextField.bottomAnchor, constant: 20),
            topSlider.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            topSlider.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -20),
            topSlider.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: -10)
        ]
        
        return (containerView, constraints)
    }
    
    // MARK: Create the table footer view
    
    func generateTableFooterView() -> (footerView: UIView, constraints: [NSLayoutConstraint]) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let bottomSlider = MultipleButtonSlider.butlerSlider(BodyFormat.allFormats().map { return $0.rawValue }, callback: bodyFormatSliderCallback)
        bottomSlider.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bottomSlider)
        
        let constraints: [NSLayoutConstraint] = [
            bottomSlider.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 0),
            bottomSlider.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            bottomSlider.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: 0)
        ]
        
        return (containerView, constraints)
    }
    
    // MARK: Slider Handlers
    
    func requestMethodSliderCallback(index: Int) {
        guard index < requestMethods.count else {
            return
        }
        
        let requestMethod = requestMethods[index]
        self.workingRequest.rawRequestMethod = requestMethod.rawValue
    }
    
    func bodyFormatSliderCallback(index: Int) {
        guard index < bodyFormats.count else {
            return
        }
        
        let bodyFormat = BodyFormat.allFormats()[index]
        self.workingRequest.rawBodyFormat = bodyFormat.rawValue
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let originalString = textField.text ?? "" as NSString
        let newString = originalString.stringByReplacingCharactersInRange(range, withString: string)
        
        workingRequest.url = newString
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        workingRequest.url = textField.text ?? ""
        return true
    }
}
