//
//  HarmonicNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

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
        return [octave, wave, attack, decay, sustain, release]
    }
    
    init(name:String, position:CGPoint = CGPoint.zero) {
        super.init(.harmonic, name: name, position: position)
    }
    
    /// Crea l'AmplitudeEnvelope
    public override func resolve(ctx: ResolveContext) throws {
        let envelope = AKAmplitudeEnvelope(
            try ctx.values[wave]!.nodeValue(),
            attackDuration: try ctx.values[attack]!.doubleValue(),
            decayDuration: try ctx.values[decay]!.doubleValue(),
            sustainLevel: try ctx.values[sustain]!.doubleValue(),
            releaseDuration: try ctx.values[release]!.doubleValue()
        )
        envelope.start()
        
        // Per ora aggiungiamo direttamente l'envelope
        ctx.addPlayingNode(envelope)
    }
}
