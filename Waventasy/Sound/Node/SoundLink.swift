//
//  SoundNodeSlotInput.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/**
 Link fra due slot nella BoardView
 */
class SoundLink : BoardRenderable {
    var boardType: BoardItemType {
        return SoundBoardItemType.link.rawValue
    }
    
    var boardIdentifier: BoardItemIdentifier {
        return id.uuidString
    }
    
    var id:NSUUID
    
    var source:SoundNode
    var target:SoundNode?
    
    var sourceSlot:SoundNodeSlot
    var targetSlot:SoundNodeSlot?
    
    init(source:SoundNode, sourceSlot:SoundNodeSlot, target:SoundNode?, targetSlot:SoundNodeSlot?) {
        self.id = NSUUID()
        self.source = source
        self.sourceSlot = sourceSlot
        self.target = target
        self.targetSlot = targetSlot
    }
}
