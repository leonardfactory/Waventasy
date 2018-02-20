//
//  SoundNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 17/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

enum SlotErrors : Error {
    case notFound(key:String)
}

/**
 Rappresenta un nodo base (Audio)
 */
class SoundNode : BoardRenderable, Hashable {
    var boardType: BoardItemType {
        return SoundBoardItemType.node.rawValue
    }
    
    var boardIdentifier: BoardItemIdentifier {
        return id.uuidString
    }
    
    // Tipi audio disponibili
    public enum NodeType {
        // Una frequenza rappresenta la base generativa. i.e. 440hz
        case frequency
        
        // Un'armonica, ovvero un moltiplicatore
        case harmonic
        
        // Una funzione
        case function
        
        // Una costante
        case constant
    }
    
    var type:NodeType
    var id: NSUUID
    var name:String
    var position:NSPoint
    
    // Link
    var inputs:[SoundNodeSlotInput] { return [] }
    var outputs:[SoundNodeSlotOutput] { return [] }
    
    init(_ type:NodeType, name:String, position:NSPoint) {
        self.type = type
        self.id = NSUUID()
        self.name = name
        self.position = position
    }
    
    // Hashable
    // -
    
    var hashValue: Int {
        return self.id.hashValue
    }
    
    static func ==(lhs: SoundNode, rhs: SoundNode) -> Bool {
        return lhs.id == rhs.id
    }
}
