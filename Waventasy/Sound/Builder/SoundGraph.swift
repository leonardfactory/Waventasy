//
//  SoundGraph.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 19/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import SwiftGraph

class SoundGraph : UnweightedGraph<SoundNode> {
    var vertexIndexes:Dictionary<SoundNode, Int> = [:]
    
    override init(vertices: [SoundNode]) {
        super.init()
        addSoundVertices(vertices: vertices)
    }
    
    /// Versione ottimizzata per registrare l'indice in un dictionary
    func addSoundVertex(_ v: SoundNode) -> Int {
        let index = addVertex(v)
        vertexIndexes[v] = index
        return index
    }
    
    func addSoundVertices(vertices: [SoundNode]) {
        for vertex in vertices {
            _ = addSoundVertex(vertex)
        }
    }
    
    /// Crea un edge a partire da un link
    func addEdge(fromLink link:SoundLink) {
        addEdge(SoundGraphEdge(
            u: vertexIndexes[link.source]!,
            v: vertexIndexes[link.target!]!,
            link: link
        ))
    }
    
    /// Elenco di edge in uscita a partire da un vertice
    func outgoingLinks(node: SoundNode) -> [SoundLink] {
        let edges = edgesForIndex(vertexIndexes[node]!) as! [SoundGraphEdge]
        return edges
            .filter({ edge in edge.link.source == node })
            .map({ edge in edge.link })
    }
}
