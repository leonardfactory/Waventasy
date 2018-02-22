//
//  SoundBuilder.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 14/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

class SoundPlayer {
    var timer:Timer? = nil
    var mixer:AKMixer = AKMixer()
    
    init(nodes: [AKNode]) {
        for node in nodes {
            mixer.connect(input: node)
            if let node = node as? AKAmplitudeEnvelope {
                node.start()
            }
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (t) in
            if (self.mixer.isStarted) {
                self.mixer.stop()
            }
            else {
                self.mixer.play()
            }
//            nodes.forEach({ envelope in
//                guard let envelope = envelope as? AKAmplitudeEnvelope else { return }
//
//                if (envelope.isStarted) {
//                    envelope.stop()
//                }
//                else {
//                    envelope.play()
//                }
//            })
        }
        
        AudioKit.output = mixer
        AudioKit.start()
        mixer.play()
    }
    
    func stop() {
        self.timer?.invalidate()
        mixer.stop()
    }
    
    deinit {
        print("deinit")
        self.timer?.invalidate()
    }
}
