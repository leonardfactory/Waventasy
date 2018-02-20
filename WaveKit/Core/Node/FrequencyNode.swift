//
//  FrequencyNode.swift
//  WaveKit
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
    
    // Input & Outputs
    public override var props: [Property] { return [frequency, wave] }
}
