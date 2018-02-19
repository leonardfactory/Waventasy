//
//  HarmonicNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 19/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

class HarmonicNode : SoundNode {
    convenience init(name: String, position: NSPoint) {
        self.init(.harmonic, name: name, position: position)
        
        inputs.append(SoundNodeSlotInput(.decimal, key:"octave", name: "Ottava"))
        inputs.append(SoundNodeSlotInput(.wave, key:"wave", name: "Onda"))
        inputs.append(SoundNodeSlotInput(.decimal, key:"attack", name: "Attack"))
        inputs.append(SoundNodeSlotInput(.decimal, key:"decay", name: "Decay"))
        inputs.append(SoundNodeSlotInput(.decimal, key:"sustain", name: "Sustain"))
        inputs.append(SoundNodeSlotInput(.decimal, key:"release", name: "Release"))
    }
}
