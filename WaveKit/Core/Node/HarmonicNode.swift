//
//  HarmonicNode.swift
//  WaveKit
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Nodo di una Armonica. Rappresenta un'AmplitudeEnvelope di AudioKit,
/// con in ingresso un oscillatore.
open class HarmonicNode : Node {
    /// Ottava
    var octave  = Input(key:"octave", name:"Ottava", value: .double(1.0))
    /// Onda in ingresso
    var wave    = Input(key: "wave", name: "Onda", value: .wave(nil))
    // ADSR
    var attack  = Input(key: "attack", name: "Attack", value: .double(1.0))
    var decay   = Input(key: "decay", name: "Decay", value: .double(1.0))
    var sustain = Input(key: "sustain", name: "Sustain", value: .double(1.0))
    var release = Input(key: "release", name: "Release", value: .double(1.0))
    
    // Input & Outputs
    public override var props: [Property] {
        return [wave, attack, decay, sustain, release]
    }
}
