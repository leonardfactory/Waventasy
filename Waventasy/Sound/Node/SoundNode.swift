//
//  SoundNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 17/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/**
 Rappresenta un nodo base (Audio)
 */
class SoundNode : BoardRenderable {
    var boardType: BoardItemType {
        return SoundBoardItemType.node.rawValue
    }
    
    var boardIdentifier: BoardItemIdentifier {
        return self.name
    }
    
    public enum NodeType {
        case frequency
        case harmonic
    }
    
    var name:String
    var position:NSPoint
    
    init(name:String, position:NSPoint) {
        self.name = name
        self.position = position
    }
}
