//
//  SoundNodeSlot.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

/// Tipi di risultati parziali
enum SlotValue {
    case wave(AKNode)
    case decimal(Float)
    case int(Int)
    case empty
    
    // Conversioni
    
    func asDouble() -> Double {
        switch self {
            case let .decimal(value): return Double(value)
            case let .int(value): return Double(value)
            default: return 0.0
        }
    }
    
    func asWave() -> AKNode {
        guard case let SlotValue.wave(node) = self else { fatalError("Impossibile trovare il nodo") }
        return node
    }
    
    var stringValue: String {
        switch self {
            case let .decimal(value): return String(value)
            case let .int(value): return String(value)
            default: return ""
        }
    }
}

/**
 Uno slot rappresenta un ingresso o un'uscita da un nodo
 */
class SoundNodeSlot : Hashable {
    var hashValue: Int { return self.id.hashValue }
    
    static func ==(lhs: SoundNodeSlot, rhs: SoundNodeSlot) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum SlotType {
        case int
        case decimal
        case wave
    }
    
    enum SlotDirection {
        case input
        case output
    }
    
    var id:NSUUID
    var type:SlotType
    var direction:SlotDirection
    var key:String
    var name:String
    
    init(_ type:SlotType, key:String, direction:SlotDirection, name:String) {
        self.id = NSUUID()
        self.type = type
        self.key = key
        self.direction = direction
        self.name = name
    }
}
