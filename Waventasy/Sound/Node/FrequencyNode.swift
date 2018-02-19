//
//  FrequencyNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

class FrequencyNode : SoundNode {
    convenience init(name: String, position: NSPoint) {
        self.init(.frequency, name: name, position: position)
        
        inputs["frequency"] = SoundNodeSlotInput(.decimal, name: "Frequenza")
        outputs["wave"]     = SoundNodeSlotOutput(.wave, name: "Onda")
    }
}
