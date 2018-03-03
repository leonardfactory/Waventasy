//
//  FrequencyNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

/// Nodo di una Frequenza. Per la precisione rappresenta
/// un oscillatore.
open class FrequencyNode : Node {
    /// Frequenza in ingresso
    var frequency = Input(key: "frequency", name: "Frequenza", value: .double(440.0))
    
    /// Uscita dell'oscillatore
    var wave = Output(key: "wave", name: "Onda", value: .wave(nil))
    
    /// Input & Outputs
    public override var props: [Property] { return [frequency, wave] }
    
    init(name:String, position:CGPoint = CGPoint.zero) {
        super.init(.frequency, name: name, position: position)
    }
    
    // Codable
    // -
    
    private enum CodingKeys : CodingKey {
        case frequency, wave
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        frequency = try container.decode(Input.self, forKey: .frequency)
        wave      = try container.decode(Output.self, forKey: .wave)
        
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(wave, forKey: .wave)
        
        try super.encode(to: encoder)
    }
    
    /// Risoluzione
    public override func resolve(ctx: ResolveContext) throws {
        let oscillator = AKOscillator()
        oscillator.frequency = try ctx.values[frequency]!.doubleValue()
        oscillator.start()
        
        ctx.values[wave] = Value.wave(oscillator)
    }
}
