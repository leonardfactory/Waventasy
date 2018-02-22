//
//  PropertyViewDelegate.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Delegato di una View di Proprietà (Input, Output) per la gestione
/// del collegamento (Link) all'interno della Board.
public protocol PropertyViewDelegate {
    // Permesso di avviare un link
    func canStartLink(from output:Output) -> Bool
    // Permesso di terminare un link
    func canEndLink(to input:Input, link:Link) -> Bool
    // Controlla se un link è in corso
    func findActiveLink() -> Link?
    // Avvio del linking
    func startLink(from output:Output) -> Link
    // Terminazione del linking
    func endLink(to input:Input, link:Link) -> Void
}
