//
//  Document.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 03/03/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/// Rappresenta un progetto Audio.
class Document: NSDocument {
    /// Nodi presenti
    public var graph: NodeGraph = NodeGraph()
    
    override init() {
        super.init()
        
        // Test
        graph.nodes.append(FrequencyNode(name: "Frequenza", position: CGPoint(x: 200.0, y:100.0)))
        graph.nodes.append(HarmonicNode(name: "Armonica", position: CGPoint(x: 300.0, y:100.0)))
    }
    
    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("SoundDocumentController")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(graph)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        let decoder = JSONDecoder()
        decoder.userInfo = [ NodeGraph.nodesKey: NodeListDecoder() ]
        
        graph = try decoder.decode(NodeGraph.self, from: data)
    }
}
