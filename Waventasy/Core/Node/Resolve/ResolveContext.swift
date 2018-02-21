//
//  ResolveContext.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

/// Il contesto di risoluzione (del Builder) processa i risultati
/// dei nodi (e dei collegamenti), e li registra in maniera temporanea,
/// in modo da poterli far utilizzare durante il resolve dei singoli nodi.
public class ResolveContext {
    /// Elenco dei valori ottenuti per le proprietà
    var values:Dictionary<Property, Value> = [:]
    
    /// Elenco dei risultati audio, quindi i nodi da riprodurre.
    var needsPlayingNodes:[AKNode] = []
    
    /// Aggiunge un nodo da riprodurre
    func addPlayingNode(_ node:AKNode) {
        self.needsPlayingNodes.append(node)
    }
}
