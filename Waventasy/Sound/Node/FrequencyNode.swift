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
        
        inputs.append(SoundNodeSlotInput(.decimal, key: "frequency", name: "Frequenza"))
        outputs.append(SoundNodeSlotOutput(.wave, key:"wave", name: "Onda"))
    }
}
