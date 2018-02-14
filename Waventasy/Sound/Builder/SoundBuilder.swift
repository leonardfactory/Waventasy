//
//  SoundBuilder.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 14/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

class SoundBuilder {
    let base = AKOscillator()
    var harmonics:[AKAmplitudeEnvelope] = []
    
    init(frequency:Double) {
        base.frequency = frequency
        base.play()
    }
    
    func withHarmonics(harmonics:[Harmonic]) -> AKMixer {
        self.harmonics = harmonics.map({ (harmonic) -> AKAmplitudeEnvelope in
            return AKAmplitudeEnvelope(
                base,
                attackDuration: harmonic.attack,
                decayDuration: harmonic.decay,
                sustainLevel: harmonic.sustain,
                releaseDuration: harmonic.release
            )
        })
        let mixer = AKMixer()
        self.harmonics.forEach { (envelope) in
            mixer.connect(input: envelope)
            envelope.play()
        }
        return mixer
    }
}
