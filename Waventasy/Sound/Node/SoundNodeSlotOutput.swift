//
//  SoundNodeSlotOutput.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

class SoundNodeSlotOutput : SoundNodeSlot {
    init(_ type: SlotType, name: String) {
        super.init(type, direction: .output, name: name)
    }
}
