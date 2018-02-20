//
//  SoundGraphEdge.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 19/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import SwiftGraph

/// Rappresenta una connessione nel grafo.
/// Aumentata per potere tenere le informazioni del link stesso
class SoundGraphEdge : UnweightedEdge {
    var link:SoundLink
    
    init(u: Int, v: Int, link:SoundLink) {
        self.link = link
        super.init(u: u, v: v, directed: true)
    }
}
