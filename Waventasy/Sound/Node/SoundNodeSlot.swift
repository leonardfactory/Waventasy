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
class SoundNodeSlot {
    enum SlotType {
        case constant
        case wave
    }
    
    var type:SlotType
    var name:String
    
    init(_ type:SlotType, name:String) {
        self.type = type
        self.name = name
    }
}
