//
//  SendRequestViewController.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

protocol SendRequestViewControllerDelegate {
    func sendRequestViewController(sendRequestViewController: SendRequestViewController, didSendRequestSuccessfully response: Response)
}

struct WorkingRequest {
    var bodyFormat: String = BodyFormat.Plain.rawValue
    var url: String = ""
    var requestMethod: String = RequestMethod.GET.rawValue
}

final class SendRequestViewController: UITableViewController, UITextFieldDelegate {
    var delegate: SendRequestViewControllerDelegate?
    
    init(nibName: String?, bundle: NSBundle?, request: Request) {
        workingRequest.bodyFormat = request.bodyFormat
        workingRequest.url = request.url
        workingRequest.requestMethod = request.requestMethod
        self.passedInRequest = request
        super.init(nibName: nibName, bundle: bundle)
    }
    
    override init(nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var passedInRequest: Request?
    
    private var workingRequest: WorkingRequest!
    private var tableViewDatasource: SendRequestTableViewDatasource!
    private var urlTextField: SemiBorderedTextField!
    
    var requestMethods = RequestMethod.allMethods()
    var bodyFormats = BodyFormat.allFormats()
    
    private var runningDataTask: NSURLSessionDataTask?
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        configureTableView(passedInRequest)
        configureTextField()
        
        let tableHeader = generateTableHeaderView()
        tableView.tableHeaderView = tableHeader.headerView
        
        let tableFooter = generateTableFooterView()
        tableView.tableFooterView = tableFooter.footerView
        
        NSLayoutConstraint.activateConstraints(tableHeader.constraints + tableFooter.constraints)
        
        let sendRequestButton = UIBarButtonItem(title: R.string.localizable.actionSend(), style: .Plain, target: self, action: #selector(sendRequest))
        navigationItem.rightBarButtonItem = sendRequestButton
        
        workingRequest = WorkingRequest()
        
        super.viewDidLoad()
    }
    
    func sendRequest() {
        let request = tableViewDatasource.generateRequest()
        request.bodyFormat = workingRequest.bodyFormat
        request.url = workingRequest.url
        request.requestMethod = workingRequest.requestMethod
        
        Cerberus.info(request)
        
        let url = NSURL(string: request.url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        Cerberus.info(url)
        
        let validURL = url != nil
        
        guard validURL else {
            urlTextField.borderColor = UIColor.redColor()
            return
        }
        
        urlTextField.borderColor = R.color.butlerColors.gray()
        
        let urlRequest = NSURLRequest.requestFrom(request)
        if let data = urlRequest?.HTTPBody {
            Cerberus.info("Sending body => \(String(data: data, encoding: NSASCIIStringEncoding))")
        }
        
        Cerberus.info("Method => \(urlRequest?.HTTPMethod)")
        Cerberus.info("Headers => \(urlRequest?.allHTTPHeaderFields)")
        
        if let runningDataTask = runningDataTask where runningDataTask.state != .Running {
            runningDataTask.cancel()
        }
        
        ProgressAlertView.show()
        
        var startTime = 0.0
        runningDataTask = GlobalURLSession.urlSession.dataTaskWithRequest(urlRequest!) { [unowned self] (data, actualResponse, error) in
            let endTime = CFAbsoluteTimeGetCurrent()
            
            dispatch_async(dispatch_get_main_queue()) {
                ProgressAlertView.hide()
                guard let delegate = self.delegate else {
                    return
                }
                
                let response = Response(request: request, httpResponse: actualResponse as? NSHTTPURLResponse, data: data, timeTaken:  endTime - startTime, error: error)
                delegate.sendRequestViewController(self, didSendRequestSuccessfully: response)
            }
        }
        runningDataTask!.resume()
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    // MARK: Setup the table view
    
    func configureTableView(request: Request?) {
        tableViewDatasource = SendRequestTableViewDatasource(self.tableView)
    
        if let request = request {
            tableViewDatasource.authorization = request.authorization
            tableViewDatasource.headers.appendContentsOf(request.headers.allObjects as! [Header])
            tableViewDatasource.parameters.appendContentsOf(request.parameters.allObjects as! [Parameter])
        }
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
        urlTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.textfieldUrl(), attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.8)])
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
        workingRequest.requestMethod = requestMethod.rawValue
    }
    
    func bodyFormatSliderCallback(index: Int) {
        guard index < bodyFormats.count else {
            return
        }
        
        let bodyFormat = BodyFormat.allFormats()[index]
        workingRequest.bodyFormat = bodyFormat.rawValue
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
