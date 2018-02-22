//
//  BoardView+NodeDelegate.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Delegato per le funzionalità del Nodo sulla Board
extension BoardView : NodeViewDelegate {
    func canStartLink(fromNode node: Node, at output: Output) -> Bool {
        return output.direction == .output && self.activeLink == nil
    }
    
    func canEndLink(toNode node: Node, at input: Input, link: Link) -> Bool {
        return (
            input.direction == .input &&
            self.activeLink != nil &&
            link.sourceProp.typeEquals(other: input)
        )
    }
    
    func findActiveLink() -> Link? {
        return self.activeLink
    }
    
    /// Aggiungo il link, inviandolo prima al delegate in caso sia da modificare.
    func startLink(fromNode node: Node, at output: Output) -> Link {
        let link = self.dataSource!.boardView(self, didStartLink: Link(source: node, sourceProp: output))
        self.activeLink = link
        // TODO: refresh.. self.activeLinkEnding =
        // Ricarico la view per mostrare il link
        self.reloadData()
        return link
    }
    
    func endLink(toNode node: Node, at input: Input, link: Link) {
        self.activeLink?.target = node
        self.activeLink?.targetProp = input
        self.dataSource?.boardView(self, didCompleteLink: link)
        self.activeLink = nil
        self.reloadData()
    }
}
