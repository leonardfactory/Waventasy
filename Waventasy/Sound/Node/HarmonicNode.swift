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
        
        inputs["octave"]    = SoundNodeSlotInput(.decimal, name: "Ottava")
        inputs["wave"]      = SoundNodeSlotInput(.wave, name: "Onda")
    }
}
