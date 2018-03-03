//
//  NodeGraph.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 03/03/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Permette la serializzazione e deserializzazione di Nodi e Link
class NodeGraph : Codable {
    var nodes:[Node] = []
    var links:[Link] = []
    
    private enum CodingKeys : CodingKey {
        case nodes, links
    }
    
    public init() {}
    
    /// Scriviamo i nodi e i link per l'encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nodes, forKey: .nodes)
        try container.encode(links, forKey: .links)
    }
    
    /// Passiamo la NodeList come userInfo al decoder dei Link
    /// in modo da avere l'accesso ai Nodi.
    public static let nodesKey = CodingUserInfoKey(rawValue: "com.leonardfactory.waventasy.nodelist")!
    
    /// Il decoding
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        /// Decoding dei Nodi.
        nodes = try container.decode(NodeListDecoder.self, forKey: .nodes).list
        
        /// Decoding dei Link. Associamo le userinfo
        if let nodesUserInfo = decoder.userInfo[NodeGraph.nodesKey] as? NodeListDecoder {
            nodesUserInfo.list = nodes
        }
        links = try container.decode([Link].self, forKey: .links)
    }
}
