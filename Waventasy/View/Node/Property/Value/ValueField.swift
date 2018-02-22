//
//  ValueFieldView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/// Protocollo per la gestione delle proprietà del ValueField. Permette
/// di ricevere e fornire i dati della proprietà.
protocol ValueFieldDelegate {
    func valueField(_ field:ValueField, didUpdateWithValue:Value)
}

/// View per la modifica di un TextField di valore.
/// Di default è vuoto in quanto non permette la modifica.
class ValueField: NSView {
    /// Vincoli richiesti dal campo
    struct Constraint : OptionSet {
        let rawValue: Int
        
        static let baseline = Constraint(rawValue: 1 << 0)
        static let bottom   = Constraint(rawValue: 1 << 1)
    }
    
    /// Proprietà da mostrare
    var property:Property
    /// Delegato
    var delegate:ValueFieldDelegate?
    
    /// Specifica se deve essere allineato con la Baseline, ecc.
    var requiredConstraints:Constraint { return [.bottom] }
    
    /// Creazione dinamica di un ValueField in base al tipo di dato fornito.
    static func create(forProperty property:Property) -> ValueField {
        switch property.value {
            case .double(_): return DoubleField(property: property)
            default: return ValueField(property: property)
        }
    }
    
    init(property:Property) {
        self.property = property
        super.init(frame: NSRect.zero)
        
        setup()
    }
    
    func setup() {
        // UI Init
        self.translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init:coder: is disabled")
    }
}
