//
//  HarmonicNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 19/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

class HarmonicNode : SoundNode {
    struct Slot {
        static let octave = "octave"
        static let wave = "wave"
        static let attack = "attack"
        static let decay = "decay"
        static let sustain = "sustain"
        static let release = "release"
    }
    
    public var octave   = SoundNodeSlotInput(.decimal, key:"octave", name: "Ottava")
    public var wave     = SoundNodeSlotInput(.wave, key:"wave", name: "Onda")
    public var attack   = SoundNodeSlotInput(.decimal, key:"attack", name: "Attack")
    public var decay    = SoundNodeSlotInput(.decimal, key:"decay", name: "Decay")
    public var sustain  = SoundNodeSlotInput(.decimal, key:"sustain", name: "Sustain")
    public var release  = SoundNodeSlotInput(.decimal, key:"release", name: "Release")
    
    override var inputs: [SoundNodeSlotInput] {
        return [octave, wave, attack, decay, sustain, release]
    }
    
    convenience init(name: String, position: NSPoint) {
        self.init(.harmonic, name: name, position: position)
        
        // Default
        octave.value = .decimal(1.0)
        attack.value = .decimal(1.0)
        decay.value = .decimal(1.0)
        sustain.value = .decimal(1.0)
        release.value = .decimal(1.0)
    }
}
