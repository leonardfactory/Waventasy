//
//  Logger.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Semplice Logger che può essere abilitato e disabilitato.
open class Logger {
    enum Level: Int {
        case debug = 0, verbose, info, warn, error, none
    }
    
    var level:Level
    
    init(level: Level) {
        self.level = level
    }
    
    private func messagesPrint(messages:[Any]) {
        for message in messages {
            print(message, terminator:" ")
        }
        print("")
    }
    
    /// Debug
    func debug(_ messages:Any...) {
        if level <= Level.debug {
            print("🛠 ", terminator:"")
            messagesPrint(messages: messages)
        }
    }
    
    /// Info
    func info(_ messages:Any...) {
        if level <= Level.info {
            print("❕ ", terminator:"")
            messagesPrint(messages: messages)
        }
    }
    
    /// Warning
    func warn(_ messages:Any...) {
        if level <= Level.warn {
            print("⚠️ ", terminator:"")
            messagesPrint(messages: messages)
        }
    }
    
    /// Error
    func err(_ messages:Any...) {
        if level <= Level.error {
            print("⛔️ ", terminator:"")
            messagesPrint(messages: messages)
        }
    }
}
