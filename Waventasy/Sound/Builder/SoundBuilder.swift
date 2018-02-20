//
//  SoundBuilder.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 19/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit
import SwiftGraph

/**
 Risolve i link e i nodi presenti nel Board e li converte in un insieme di
 armoniche da riprodurre.
 */
class SoundBuilder {
    /// Errori di creazione
    enum BuildErrors: Error {
        case cannotSort
        case missingSlotValue(name:String)
        case unknownNode
    }
    
    var nodes:[SoundNode]
    var links:[SoundLink]
    
    /// Grafo contenente tutti i nodi, per ordinarlo topologicamenti
    var graph:SoundGraph
    
    /// Elenco dei risultati di valutazione del grafo, passo dopo passo.
    var results:Dictionary<SoundNodeSlot, SlotValue> = [:]
    
    /// Output
    var soundAudioNodes:[AKNode] = []
    
    init(nodes: [SoundNode], links:[SoundLink]) {
        self.nodes = nodes
        self.links = links
        
        self.graph = SoundGraph(vertices: self.nodes)
        self.links.forEach({ link in
            if link.target != nil {
                self.graph.addEdge(fromLink: link)
            }
        })
    }
    
    func resolve() throws -> [AKNode] {
        do {
            guard let orderedNodes = self.graph.topologicalSort() else {
                throw BuildErrors.cannotSort
            }
            
            for node in orderedNodes {
                try resolveNode(node: node)
            }
        }
        catch {
            print("Impossibile completare per via di un errore di Build. \(error)")
            return []
        }
        
        print("soundAudioNodes", soundAudioNodes)
        return self.soundAudioNodes
    }
    
    // Generatori
    // -
    
    /// Resolve, ovvero genera gli output per i vari nodi
    func resolveNode(node: SoundNode) throws {
        // 1. Estraggo gli input
        try resolveNodeInputs(node: node)
        
        // 2. Input -> Output
        switch node {
            case let frequency as FrequencyNode: try resolveFrequencyNode(node: frequency)
            case let harmonic as HarmonicNode: try resolveHarmonicNode(node: harmonic)
            case let constant as ConstantNode: try resolveConstantNode(node: constant)
            default: throw BuildErrors.unknownNode
        }
        
        // 3. Propagazione degli output
        propagateNodeOutputs(node: node)
    }
    
    func resolveFrequencyNode(node: FrequencyNode) throws {
        let oscillator = AKOscillator()
        oscillator.frequency = results[node.frequency]!.asDouble()
        oscillator.start()
        
        results[node.wave] = SlotValue.wave(oscillator)
    }
    
    func resolveHarmonicNode(node: HarmonicNode) throws {
        let envelope = AKAmplitudeEnvelope(
            results[node.wave]!.asWave(),
            attackDuration: results[node.attack]!.asDouble(),
            decayDuration: results[node.decay]!.asDouble(),
            sustainLevel: results[node.sustain]!.asDouble(),
            releaseDuration: results[node.release]!.asDouble()
        )
        envelope.start()
        
        // Per ora aggiungiamo direttamente l'envelope
        soundAudioNodes.append(envelope)
    }
    
    func resolveConstantNode(node: ConstantNode) throws {
        results[node.outputValue] = results[node.value]
    }
    
    // Funzioni di input / output
    // -

    /// Per un nodo, provvediamo a estrapolare i dati di input.
    /// Questi possono venire da un Link, se esiste, oppure dal
    /// valore inserito nell'UI dall'utente.
    /// In caso nessuno dei due sia impostato, lanciamento un errore.
    func resolveNodeInputs(node: SoundNode) throws {
        print("• Resolving Inputs..", node.name)
        for slot in node.inputs {
            print("  • Input: ", slot.name)
            // 1. Controllo i link
            if results[slot] != nil { continue }
            
            // 2. Prendo il valore dall'input
            print("    • From value", slot.value)
            switch slot.value {
                case .decimal, .int:
                    results[slot] = slot.value
                
                case .empty, .wave(node: _):
                    // Non c'è modo di inserire un'onda lato UI
                    throw BuildErrors.missingSlotValue(name: slot.name)
            }
        }
    }
    
    /// Per un nodo, inseriamo tutti i dati di output, anche temporanei,
    /// nella tabella dei risultati (parziali), propagandoli agli input
    func propagateNodeOutputs(node: SoundNode) {
        let outgoingLinks = graph.outgoingLinks(node: node)
        
        for output in node.outputs {
            let targetSlots = outgoingLinks
                .filter({ link in link.sourceSlot == output })
                .map({ link in link.targetSlot! })
            
            for targetSlot in targetSlots {
                results[targetSlot] = results[output]
            }
        }
    }
}
