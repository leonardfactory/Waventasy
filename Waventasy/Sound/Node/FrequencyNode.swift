//
//  FrequencyNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

class FrequencyNode : SoundNode {
    struct Slot {
        static let frequency = "frequency"
        static let wave = "wave"
    }
    
    // Input & Output
    public var frequency = SoundNodeSlotInput(.decimal, key: Slot.frequency, name: "Frequenza")
    public var wave = SoundNodeSlotOutput(.wave, key: Slot.wave, name: "Onda")

    override var inputs: [SoundNodeSlotInput] { return [frequency] }
    override var outputs: [SoundNodeSlotOutput] { return [wave] }
    
    convenience init(name: String, position: NSPoint) {
        self.init(.frequency, name: name, position: position)
        
        // Default
        frequency.value = .decimal(440.0)
    }
}
