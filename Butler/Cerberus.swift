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
    
    static func debug(items: Any...) {
        logger.debug(items)
    }
    
    static func info(items: Any...) {
        logger.info(items)
    }
    
    static func warning(items: Any...) {
        logger.warning(items)
    }
    
    static func trace(items: Any...) {
        logger.trace(items)
    }
    
    static func error(items: Any...) {
        logger.error(items)
    }
}

extension Formatters {
    static let Butler = Formatter("[%@ %@] %@", [
        .Level,
        .Date("HH:mm:ss"),
        .Message
        ])
}