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
    
    // Codable
    // -
    
    private enum CodingKeys : CodingKey {
        case octave, wave, attack, decay, sustain, release
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        octave    = try container.decode(Input.self, forKey: .octave)
        wave      = try container.decode(Input.self, forKey: .wave)
        attack    = try container.decode(Input.self, forKey: .attack)
        decay     = try container.decode(Input.self, forKey: .decay)
        sustain   = try container.decode(Input.self, forKey: .sustain)
        release   = try container.decode(Input.self, forKey: .release)
        
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(octave, forKey: .octave)
        try container.encode(wave, forKey: .wave)
        try container.encode(attack, forKey: .attack)
        try container.encode(decay, forKey: .decay)
        try container.encode(sustain, forKey: .sustain)
        try container.encode(release, forKey: .release)
        
        try super.encode(to: encoder)
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
