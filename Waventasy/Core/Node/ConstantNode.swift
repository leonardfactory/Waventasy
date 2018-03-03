//
//  ConstantNode.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

open class ConstantNode : Node {
    public var value = Input(key: "value", name:"Valore", value: .double(nil))
    public var outputValue = Output(key: "outputValue", name:"Ris.", value: .double(nil))
    
    public override var props: [Property] {
        return [value, outputValue]
    }
    
    init(name:String, position:CGPoint = CGPoint.zero) {
        super.init(.constant, name: name, position: position)
    }
    
    // Codable
    // -
    
    private enum CodingKeys : CodingKey {
        case value, outputValue
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value       = try container.decode(Input.self, forKey: .value)
        outputValue = try container.decode(Output.self, forKey: .outputValue)
        
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(outputValue, forKey: .outputValue)
        
        try super.encode(to: encoder)
    }
    
    
    /// Risoluzione della costante
    public override func resolve(ctx: ResolveContext) throws {
        ctx.values[outputValue] = ctx.values[value]
    }
}
