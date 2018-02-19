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
    convenience init(name: String, position: NSPoint) {
        self.init(.constant, name: name, position: position)
        
        inputs.append(SoundNodeSlotInput(.decimal, key:"value", name: "Valore"))
        outputs.append(SoundNodeSlotOutput(.decimal, key:"value", name: "Risultato"))
    }
}

