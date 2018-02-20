//
//  ConstantNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 19/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

import Foundation

class ConstantNode : SoundNode {
    
    public var value = SoundNodeSlotInput(.decimal, key:"value", name: "Valore")
    public var outputValue = SoundNodeSlotOutput(.decimal, key:"outputValue", name: "Ris.")
    
    override var inputs: [SoundNodeSlotInput] { return [value] }
    override var outputs: [SoundNodeSlotOutput] { return [outputValue] }
    
    convenience init(name: String, position: NSPoint) {
        self.init(.constant, name: name, position: position)
    }
}

