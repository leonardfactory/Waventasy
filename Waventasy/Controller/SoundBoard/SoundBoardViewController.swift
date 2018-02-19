//
//  SoundBoardViewController.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 15/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

class SoundBoardViewController: NSViewController {
    
    @IBOutlet weak var scrollView:SoundBoardScrollView?
    @IBOutlet weak var rightSideBarView:NSView?
    @IBOutlet weak var rightSideBarXConstraint: NSLayoutConstraint!
    @IBOutlet weak var boardView: BoardView!
    
    var isRightSidebarShown: Bool = false
    
    var nodes:[SoundNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.window?.makeFirstResponder(self.scrollView)
        self.scrollView?.becomeFirstResponder()
        printResponderChain(from: self.scrollView)
        
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
        self.nodes.append(SoundNode(.harmonic, name: "Nodo Demo", position: NSPoint(x:100.0, y:100.0)))
        self.nodes.append(SoundNode(.frequency, name: "440Hz", position: NSPoint(x:100.0, y:225.0)))
        self.nodes.append(SoundNode(.frequency, name: "880Hz", position: NSPoint(x:1000.0, y:600.0)))
        
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
//
//    override func keyDown(with event: NSEvent) {
//        print("hello")
//    }
//
    // Translucent
    private func setupVibrantViews() {
        // Sidebar
        let sidebarVibrant = NSVisualEffectView(frame: self.rightSideBarView!.bounds)
        sidebarVibrant.autoresizingMask = [.height, .width]
        sidebarVibrant.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        self.rightSideBarView?.addSubview(sidebarVibrant, positioned:NSWindow.OrderingMode.below, relativeTo: nil)
    }
    
    // Aggiunta dei noid
    public func addSoundNode(type: SoundNode.NodeType) {
        print("addnode", type)
        let visibleRect = self.scrollView!.documentVisibleRect
        let position = self.boardView.toGridPoint(point: CGPoint(x: visibleRect.midX, y: visibleRect.midY))
        var node:SoundNode
        if type == .frequency {
            node = FrequencyNode(name: "Frequenza", position: position)
        }
        else {
            node = HarmonicNode(name: "Armonica", position: position)
        }
        
        self.nodes.append(node)
        self.boardView.reloadData()
    }
}

extension SoundBoardViewController: BoardDelegate, BoardDataSource {
    // Display e/o Update di un nodo
    func boardView(_ boardView: BoardView, item: BoardRenderable, fromExistingView existingView: BoardItemView?) -> BoardItemView? {
        guard let soundNode = item as? SoundNode else { return nil }
        guard let soundNodeView = existingView as? SoundNodeView? else { fatalError("Non implementato") }
        let itemView = soundNodeView ?? SoundNodeView(node: soundNode)
        
        // Impostazioni
        if (existingView == nil) {
            itemView.node = soundNode
        }
        
        return itemView
    }
    
    // Ottiene l'elenco dei nodi
    func boardView(itemsIn boardView: BoardView) -> [BoardRenderable] {
        return self.nodes
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
}
