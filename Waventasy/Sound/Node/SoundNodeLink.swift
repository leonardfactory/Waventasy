//
//  SoundNodeSlotInput.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

class SoundNodeLink {
    var source:SoundNode
    var target:SoundNode
    
    var sourceSlot:String
    var targetSlot:String
    
    init(source:SoundNode, sourceSlot:String, target:SoundNode, targetSlot:String) {
        self.source = source
        self.sourceSlot = sourceSlot
        self.target = target
        self.targetSlot = targetSlot
    }
}
