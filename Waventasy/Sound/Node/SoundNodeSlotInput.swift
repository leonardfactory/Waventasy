//
//  SoundNodeSlotInput.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

class SoundNodeSlotInput : SoundNodeSlot {
    public var floatValue: Float? = nil
    public var intValue: Int? = nil
    
    init(_ type: SlotType, name: String) {
        super.init(type, direction: .input, name: name)
    }
}
