//
//  SoundNodeSlot.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/**
 Uno slot rappresenta un ingresso o un'uscita da un nodo
 */
class SoundNodeSlot : Hashable {
    var hashValue: Int { return self.key.hashValue }
    
    static func ==(lhs: SoundNodeSlot, rhs: SoundNodeSlot) -> Bool {
        return lhs.key == rhs.key
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
    
    var type:SlotType
    var direction:SlotDirection
    var key:String
    var name:String
    
    init(_ type:SlotType, key:String, direction:SlotDirection, name:String) {
        self.type = type
        self.key = key
        self.direction = direction
        self.name = name
    }
}
