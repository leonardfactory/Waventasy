//
//  Slot.swift
//  WaveKit
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

/// Rappresenta un parametro in ingresso o in uscita
/// di un nodo.
open class Property : Hashable {
    public var id:NSUUID = NSUUID()
    
    /// La chiave della proprietà
    public var key:String
    /// Il nome della proprietà, per la visualizzazione
    public var name:String
    /// Il valore assunto
    public var value:Value
    
    public init(key:String, name:String, value:Value) {
        self.key = key
        self.name = name
        self.value = value
    }
    
    /// Ottiene il valore della proprietà.
    public var doubleValue:Double {
        guard case let .double(.some(d)) = value else { fatalError() }
        return d
    }
    
    public var waveValue:AKNode {
        guard case let .wave(.some(w)) = value else { fatalError() }
        return w
    }
    
    // MARK: Implementazione di Hashable
    
    public var hashValue: Int {
        return id.hash
    }
    
    public static func ==(lhs: Property, rhs: Property) -> Bool {
        return lhs.id == rhs.id
    }
}
