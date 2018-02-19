//
//  SoundNodeSlotDelegate.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 19/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

protocol SoundNodeSlotDelegate {
    // Permesso di avviare un link
    func canStartLink(fromSlot slot:SoundNodeSlot) -> Bool
    // Permesso di terminare un link
    func canEndLink(toSlot slot:SoundNodeSlot, link:SoundLink) -> Bool
    // Controlla se un link è in corso
    func findActiveLink() -> SoundLink?
    // Avvio del linking
    func startLink(fromSlot slot:SoundNodeSlot) -> SoundLink
    // Terminazione del linking
    func endLink(toSlot slot:SoundNodeSlot, link:SoundLink) -> Void
}
