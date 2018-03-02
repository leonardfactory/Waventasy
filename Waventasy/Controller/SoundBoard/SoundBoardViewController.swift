//
//  SoundBoardViewController.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 15/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa
import AudioKit

/// Gestione principale della creazione e della visualizzazione dei Nodi e dei Link
/// Su una Board.
class SoundBoardViewController: NSViewController {
    
    @IBOutlet weak var scrollView:BoardScrollView?
    @IBOutlet weak var rightSideBarView:NSView?
    @IBOutlet weak var rightSideBarXConstraint: NSLayoutConstraint!
    @IBOutlet weak var boardView: BoardView!
    
    var isRightSidebarShown: Bool = false
    
    var nodes:[Node] = []
    var links:[Link] = []
    
    var player:SoundPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nascondo la rightSidebar
        self.rightSideBarXConstraint.constant = -self.rightSideBarView!.frame.size.width
        self.isRightSidebarShown = false
        
        // Vibrant
        self.setupVibrantViews()
        
        // Ottimizzazioni per la BoardView
        self.view.wantsLayer = true
        self.boardView.dataSource = self
        self.boardView.delegate = self
        
        // Test
        self.nodes.append(FrequencyNode(name: "Frequenza", position: CGPoint(x: 200.0, y:100.0)))
        self.nodes.append(HarmonicNode(name: "Armonica", position: CGPoint(x: 300.0, y:100.0)))
        
        self.boardView.reloadData()
    }
    
    
    // Sidebar Management
    // -
    public func toggleRightSidebar() {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            
            self.rightSideBarXConstraint.animator().constant =
                self.isRightSidebarShown ? -self.rightSideBarView!.frame.size.width : 0
            
            self.view.layoutSubtreeIfNeeded()
        }, completionHandler: {
            self.isRightSidebarShown = !self.isRightSidebarShown
        })
    }
    
    public func toggleLeftSidebar() {
        print("Toggle left..")
    }
    
    // Translucent
    private func setupVibrantViews() {
        // Sidebar
        let sidebarVibrant = NSVisualEffectView(frame: self.rightSideBarView!.bounds)
        sidebarVibrant.autoresizingMask = [.height, .width]
        sidebarVibrant.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        self.rightSideBarView?.addSubview(sidebarVibrant, positioned:NSWindow.OrderingMode.below, relativeTo: nil)
    }
    
    // Aggiunta dei nodi
    public func addSoundNode(type: NodeType) {
        let visibleRect = self.scrollView!.documentVisibleRect
        let position = self.boardView.toGridPoint(point: visibleRect.center())
        var node:Node? = nil
        switch type {
            case .frequency:
                node = FrequencyNode(name: "Frequenza", position: position)
            
            case .harmonic:
                node = HarmonicNode(name: "Armonica", position: position)
            
            case .constant:
                node = ConstantNode(name: "Costante", position: position)
        }
        
        self.nodes.append(node!)
        self.boardView.reloadData()
    }
    
    // Player
    // -
    public func play() {
        do {
            let nodes = try SoundBuilder(nodes: self.nodes, links: self.links).resolve()
            self.player = SoundPlayer(nodes: nodes)
        } 
        catch {
            print("Errore nel builder \(error)")
        }
    }
    
    public func stop() {
        self.player?.stop()
    }
}

/// Gestione della Board
extension SoundBoardViewController: BoardDelegate, BoardDataSource {
    /// Display e/o Update di un nodo
    func boardView(_ boardView: BoardView, item: BoardItem, fromExistingView existingView: BoardItemView?) -> BoardItemView? {
        
        switch (item.itemType) {
        // 1. Nodi
        case BoardItemType.node:
            guard let node     = item as? Node else { return nil }
            guard let nodeView = existingView as? NodeView? else { fatalError("View errata") }
            let itemView = nodeView ?? NodeView(node: node)
            itemView.nodeDelegate = self.boardView
            
            // Impostazioni
            if (existingView == nil) {
                itemView.node = node
            }
            
            return itemView
            
        // 2. Link
        case BoardItemType.link:
            guard let link     = item as? Link else { return nil }
            guard let linkView = existingView as? LinkView? else { fatalError("View errata") }
            let itemView = linkView ?? LinkView(link: link)
            itemView.linkDelegate = self.boardView
            
            // Ottimizzabili. Chiama il trigger del refresh
            itemView.link = link
            
            return itemView
        }
        
        
    }
    
    /// Ottiene l'elenco dei nodi e dei link
    func itemsIn(boardView: BoardView) -> [BoardItem] {
        return (self.nodes as [BoardItem]) + (self.links as [BoardItem])
    }
    
    /// Calcola le dimensioni
    func contentRectFor(boardView: BoardView) -> NSRect {
        var minPoint = CGPoint.zero
        var maxPoint = CGPoint.zero
        
        for node in self.nodes {
            if (node.position.x < minPoint.x) { minPoint.x = node.position.x }
            if (node.position.y < minPoint.y) { minPoint.y = node.position.y }
            if (node.position.x + 100 > maxPoint.x) { maxPoint.x = node.position.x + 100 }
            if (node.position.y + 100 > maxPoint.y) { maxPoint.y = node.position.y + 100 }
        }
        
        let size = NSSize(
            width: max(self.scrollView!.frame.width, maxPoint.x - minPoint.x),
            height: max(self.scrollView!.frame.height, maxPoint.y - minPoint.y)
        )
        
        return NSRect(origin:minPoint, size: size)
    }
    
    /// Quando un link viene aggiunto, lo inseriamo nell'elenco
    func boardView(_ boardView: BoardView, didStartLink link: Link) -> Link {
        self.links.append(link)
        return link
    }
    
    func boardView(_ boardView: BoardView, didCompleteLink: Link) {
        // todo: Completato, potremmo segnare come "abilitato" il play
    }
    
    /// Anche se è ottimizzabile, il concetto è che quando spostiamo un elemento
    /// refreshiamo la view in modo da mostrare gli elementi spostati.
    func boardView(_ boardView: BoardView, mouseDraggedForItem itemView: BoardItemView) {
        self.boardView.reloadData()
    }
    
    // Linking
    func boardView(_ boardView: BoardView, mouseMoved: NSEvent) {
        self.boardView.reloadData()
    }
    
    /// Dragging
    var isScrollViewDragging:Bool {
        return self.scrollView!.isDragMode
    }
}

