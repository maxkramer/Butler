//
//  Cerberus.swift
//  Butler
//
//  Created by Max Kramer on 27/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import Log

final class Cerberus {
    static private var logger: Logger = {
        let log = Logger(formatter: Formatter.Butler, theme: Themes.TomorrowNight, minLevel: Level.Trace)
        return log
    }()
    
    static func debug(items: Any..., path: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        logger.debug(items, file: path, line: line, column: column, function: function)
    }
    
    static func info(items: Any..., path: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        logger.info(items, file: path, line: line, column: column, function: function)
    }
    
    static func warning(items: Any..., path: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        logger.warning(items, file: path, line: line, column: column, function: function)
    }
    
    static func trace(items: Any..., path: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        logger.trace(items, file: path, line: line, column: column, function: function)
    }
    
    static func error(items: Any..., path: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        logger.error(items, file: path, line: line, column: column, function: function)
    }
}

extension Formatters {
    static let Butler = Formatter("[%@ %@ %@:%@] %@", [
        .Level,
        .Date("HH:mm:ss"),
        .File(fullPath: false, fileExtension: true),
        .Line,
        .Message
        ])
}