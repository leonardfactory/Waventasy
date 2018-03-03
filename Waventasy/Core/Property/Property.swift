//
//  Slot.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

/// Rappresenta un parametro in ingresso o in uscita
/// di un nodo.
public class Property : Hashable, Codable {
    /// Per comodità, rappresentiamo la direction come un Enum
    public enum Direction : String, Codable {
        case input, output
    }
    
    public var id:UUID = UUID()
    
    /// Direzione
    public var direction:Direction
    /// La chiave della proprietà
    public var key:String
    /// Il nome della proprietà, per la visualizzazione
    public var name:String
    /// Il valore assunto
    public var value:Value
    
    public init(_ direction:Direction, key:String, name:String, value:Value) {
        self.direction = direction
        self.key = key
        self.name = name
        self.value = value
    }
    
    /// Controlla se due Proprietà hanno lo stesso tipo di valore
    public func typeEquals(other:Property) -> Bool {
        return value.typeEquals(other: other.value)
    }
    
    // MARK: Codable
    
//    private enum CodingKeys : CodingKey {
//        case direction, key, name, value
//    }
//
//    public required init(from decoder: Decoder) throws {
//
//    }
    
    // MARK: Implementazione di Hashable
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: Property, rhs: Property) -> Bool {
        return lhs.id == rhs.id
    }
}
