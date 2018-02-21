//
//  Value.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

/// Protocollo per la gestione delle proprietà
public enum Value {
    public enum ValueError : Error {
        case wrongType
    }
    
    case double(Double?)
    case int(Int?)
    case wave(AKNode?)
    case none
    
    /// Controlla se i due valori si equivalgono
    public func typeEquals(other:Value) -> Bool {
        switch (self, other) {
            case (.double(_), .double(_)):
                return true
            case (.int(_), .int(_)):
                return true
            case (.wave(_), .wave(_)):
                return true
            case (.none, .none):
                return true
            default:
                return false
        }
    }
    
    // Casting
    // -
    
    /// Conversione obbligata a Double
    func doubleValue() throws -> Double {
        guard case let .double(.some(value)) = self else { throw ValueError.wrongType }
        return value
    }
    
    /// Conversione obbligata a Int
    func intValue() throws -> Int {
        guard case let .int(.some(value)) = self else { throw ValueError.wrongType }
        return value
    }
    
    /// Conversione obbligata a AKNode
    func nodeValue() throws -> AKNode {
        guard case let .wave(.some(value)) = self else { throw ValueError.wrongType }
        return value
    }
}

struct ValueFormatters {
    /// Formatter per i valori di tipo Double
    static let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4
        return formatter
    }()
}

/// Gestisce la conversione in Stringa
extension Value {
//    /// Rappresentazione come stringa
//    var stringValue:String {
//        switch self {
//        case let .double(d): return ValueFormatters.doubleFormatter.string(from: NSNumber(double: d)) ?? ""
//            case let .int(i): return String(i) ?? ""
//            case let .wave(_): return "" // non rappresentabile
//            default: return ""
//        }
//    }
}
