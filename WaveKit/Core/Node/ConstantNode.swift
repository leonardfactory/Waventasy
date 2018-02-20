//
//  ConstantNode.swift
//  WaveKit
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
}
