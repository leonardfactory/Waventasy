//
//  SoundBoardViewController.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 15/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa
import AudioKit

class SoundBoardViewController: NSViewController {
    
    @IBOutlet weak var scrollView:SoundBoardScrollView?
    @IBOutlet weak var rightSideBarView:NSView?
    @IBOutlet weak var rightSideBarXConstraint: NSLayoutConstraint!
    @IBOutlet weak var boardView: BoardView!
    
    var isRightSidebarShown: Bool = false
    
    var nodes:[SoundNode] = []
    var links:[SoundLink] = []
    
    var activeLink:SoundLink? = nil
    // Location temporanea
    var activeLinkEnding:CGPoint? = nil
    
    var player:SoundPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView?.becomeFirstResponder()
        
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
//        self.nodes.append(SoundNode(.harmonic, name: "Nodo Demo", position: NSPoint(x:100.0, y:100.0)))
//        self.nodes.append(SoundNode(.frequency, name: "440Hz", position: NSPoint(x:100.0, y:225.0)))
//        self.nodes.append(SoundNode(.frequency, name: "880Hz", position: NSPoint(x:1000.0, y:600.0)))
        
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
    public func addSoundNode(type: SoundNode.NodeType) {
        print("addnode", type)
        let visibleRect = self.scrollView!.documentVisibleRect
        let position = self.boardView.toGridPoint(point: CGPoint(x: visibleRect.midX, y: visibleRect.midY))
        var node:SoundNode? = nil
        switch type {
        case .frequency:
            node = FrequencyNode(name: "Frequenza", position: position)
            
        case .harmonic:
            node = HarmonicNode(name: "Armonica", position: position)
            
        case .constant:
            node = ConstantNode(name: "Costante", position: position)
            
        default:
            print("non implementato")
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

extension SoundBoardViewController: BoardDelegate, BoardDataSource {
    // Display e/o Update di un nodo
    func boardView(_ boardView: BoardView, item: BoardRenderable, fromExistingView existingView: BoardItemView?) -> BoardItemView? {
        
        switch (item.boardType) {
        // 1. Nodi
        case SoundBoardItemType.node.rawValue:
            guard let soundNode     = item as? SoundNode else { return nil }
            guard let soundNodeView = existingView as? SoundNodeView? else { fatalError("View errata") }
            let itemView = soundNodeView ?? SoundNodeView(node: soundNode)
            itemView.nodeDelegate = self
            
            // Impostazioni
            if (existingView == nil) {
                itemView.node = soundNode
            }
            
            return itemView
            
        // 2. Link
        case SoundBoardItemType.link.rawValue:
            guard let soundLink     = item as? SoundLink else { return nil }
            guard let soundLinkView = existingView as? SoundLinkView? else { fatalError("View errata") }
            let itemView = soundLinkView ?? SoundLinkView(link: soundLink)
            itemView.linkDelegate = self
            
            // Ottimizzabili. Chiama il trigger del refresh
            itemView.link = soundLink
            
            return itemView
            
        default: return nil
        }
        
        
    }
    
    // Ottiene l'elenco dei nodi
    func boardView(itemsIn boardView: BoardView) -> [BoardRenderable] {
        return (self.nodes as [BoardRenderable]) + (self.links as [BoardRenderable])
    }
    
    // Calcola le dimensioni
    func boardView(contentRectFor boardView: BoardView) -> NSRect {
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
    
    // Dragging
    var isScrollViewDragging:Bool {
        return self.scrollView!.isDragMode
    }
    
    func boardView(_ boardView: BoardView, mouseDraggedForItem itemView: BoardItemView) {
        self.boardView.reloadData()
    }
    
    // Linking
    func boardView(_ boardView: BoardView, mouseMoved: NSEvent) {
        if self.activeLink != nil {
            self.activeLinkEnding = self.view.convert(mouseMoved.locationInWindow, to: boardView as NSView?)
            self.boardView.reloadData()
        }
    }
}

/**
 Gestione dei nodi
 */
extension SoundBoardViewController : SoundNodeViewDelegate {
    func canStartLink(fromNode node: SoundNode, atSlot slot: SoundNodeSlot) -> Bool {
        return slot.direction == .output && self.activeLink == nil
    }
    
    func canEndLink(toNode node: SoundNode, atSlot slot: SoundNodeSlot, link: SoundLink) -> Bool {
        return  slot.direction == .input &&
                self.activeLink != nil &&
                link.sourceSlot.type == slot.type
    }
    
    func findActiveLink() -> SoundLink? {
        return self.activeLink
    }
    
    func startLink(fromNode node: SoundNode, atSlot slot: SoundNodeSlot) -> SoundLink {
        let link = SoundLink(source: node, sourceSlot: slot, target: nil, targetSlot: nil)
        self.activeLink = link
        self.links.append(link)
        self.boardView.reloadData()
        return link
    }
    
    func endLink(toNode node: SoundNode, atSlot slot: SoundNodeSlot, link: SoundLink) {
        self.activeLink?.target = node
        self.activeLink?.targetSlot = slot
        self.activeLink = nil
        self.boardView.reloadData()
    }
}

/**
 Gestione dei link
 */
extension SoundBoardViewController : SoundLinkViewDelegate {
    func color(forLink link: SoundLink?) -> NSColor {
        return link?.target == nil
            ? SoundNodeLinkColors.activeLineColor
            : SoundNodeLinkColors.completeLineColor
    }
    
    func startingPoint(forLink link: SoundLink?) -> CGPoint {
        if  let source = link?.source,
            let sourceView = boardView.view(forItem: source.boardIdentifier) as? SoundNodeView,
            let sourceSlot = link?.sourceSlot as? SoundNodeSlotOutput,
            let sourceSlotView = sourceView.outputsSlotsViewItems[sourceSlot]
        {
            return sourceSlotView.convert(
                sourceSlotView.linkButton.frame.center(),
                to: boardView
            )
        }
        
        fatalError("Impossibile trovare lo slot")
    }
    
    func endingPoint(forLink link: SoundLink?) -> CGPoint {
        if link?.target == nil {
            return self.activeLinkEnding ?? self.startingPoint(forLink:link)
        }
        
        if  let target = link?.target,
            let targetView = boardView.view(forItem: target.boardIdentifier) as? SoundNodeView,
            let targetSlot = link?.targetSlot as? SoundNodeSlotInput,
            let targetSlotView = targetView.inputSlotsViewItems[targetSlot]
        {
            return targetSlotView.convert(
                targetSlotView.linkButton.frame.center(),
                to: boardView
            )
        }
        
        return CGPoint.zero
    }
}

