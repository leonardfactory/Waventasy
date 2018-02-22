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
    
    /// Risoluzione della costante
    public override func resolve(ctx: ResolveContext) throws {
        ctx.values[outputValue] = ctx.values[value]
    }
}
