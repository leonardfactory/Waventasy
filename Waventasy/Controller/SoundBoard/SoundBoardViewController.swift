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
        
        // Do view setup here.
        
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
        var node:SoundNode
        if type == .frequency {
            node = FrequencyNode(name: "Hello", position: CGPoint(x: visibleRect.midX, y: visibleRect.midY))
        }
        else {
            node = SoundNode(type, name: "Hello", position:CGPoint(x: visibleRect.midX, y: visibleRect.midY))
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
    func boardView(contentSizeFor boardView: BoardView) -> NSSize {
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
        
        return size
    }
}

/**
 Visualizzazione dei nodi.
 */
extension SoundBoardViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    // Singola sezione
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    // Numero di nodi
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nodes.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(
            withIdentifier: NSUserInterfaceItemIdentifier("SoundNodeCollectionViewItem"),
            for: indexPath
        )
        guard let nodeItem = item as? SoundNodeCollectionViewItem else { return item }
        nodeItem.node = self.nodes[indexPath.item]
//        nodeItem.view.bounds = NSRect(
//            x: 100.0,
//            y: CGFloat(indexPath.item) * 140.0 + 100.0,
//            width: nodeItem.view.bounds.width,
//            height: nodeItem.view.bounds.height
//        )
        
        return nodeItem
    }
    
    // Dimensioni di Layout
    // -
    
    
    
//    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
////        print("Yeah, drag many")
//        return true
//    }
//
//    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
//        return NSDragOperation.move
//    }
//
//    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
//        return NSPasteboardItem(pasteboardPropertyList: self.nodes[indexPath.item].name, ofType: NSPasteboard.PasteboardType.string)
//    }
}
