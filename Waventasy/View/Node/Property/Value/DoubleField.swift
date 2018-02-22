//
//  DoubleFieldView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/// Mostra un valore di tipo Double
class DoubleField: ValueField {
    /// Input
    var inputField:NSTextField!
    
    override init(property: Property) {
        super.init(property: property)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init:coder is not implemented")
    }
    
    override func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard case let .double(double) = property.value else { fatalError("Proprietà \(property.name) non di tipo Double. Field errato" ) }
        print("Building inputField")
        inputField = NSTextField(string: "")
        inputField.wantsLayer = true
        inputField.font = NSFont.systemFont(ofSize: 10.0)
        inputField.textColor = NSColor.white
        inputField.backgroundColor = NSColor(hex: 0xffffff, alpha:0.5)
        inputField.isBordered = false
        inputField.bezelStyle = .roundedBezel
        inputField.formatter = ValueFormatters.doubleFormatter
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.layer = CALayer()
        inputField.layer?.backgroundColor = NSColor(hex: 0xffffff, alpha:0.5).cgColor
        inputField.layer?.cornerRadius = 3.0
        inputField.layer?.borderWidth = 0
        inputField.drawsBackground = false
        inputField.delegate = self
        if let double = double {
            inputField.doubleValue = double
        }
        addSubview(inputField)
        
        inputField.widthAnchor.constraint(greaterThanOrEqualToConstant: 26.0).isActive = true
        
        inputField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        inputField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
        inputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
    }
    
    /// Allineamento alla baseline
    override var requiredConstraints:Constraint { return [.baseline] }
    
    /// Necessario per permettere a questa view di essere allineata mediante il firstBaselineAnchor
    /// anche se non è un TextField.
    override var firstBaselineOffsetFromTop: CGFloat {
        return inputField.firstBaselineOffsetFromTop
    }
}

/// Gestisco il TextChange
extension DoubleField : NSTextFieldDelegate {
    /// EndEditing. Non lo facciamo al change per evitare di resettare, tramite
    /// la chiamata di `doubleValue`, il valore del campo.
    /// vedi: https://stackoverflow.com/questions/6337464/nsnumberformatter-doesnt-allow-typing-decimal-numbers
    override func controlTextDidEndEditing(_ obj: Notification) {
        let value = Value.double(inputField.doubleValue)
        property.value = value
        delegate?.valueField(self, didUpdateWithValue: value)
        
        // Lose focus
        self.window?.makeFirstResponder(nil)
    }
}
