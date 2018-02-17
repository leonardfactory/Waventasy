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
    
    @IBOutlet weak var collectionView: NSCollectionView?
    
    var isRightSidebarShown: Bool = false
    
    var nodes:[SoundNode] = []
    var nodeItemTemplateView:SoundNodeCollectionViewItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        
        // Nascondo la rightSidebar
        self.rightSideBarXConstraint.constant = -self.rightSideBarView!.frame.size.width
        self.isRightSidebarShown = false
        
        // Ottimizzazioni per la CollectionView
        self.view.wantsLayer = true
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        self.collectionView?.setDraggingSourceOperationMask(NSDragOperation.move, forLocal: true)
        
        
        self.nodeItemTemplateView = SoundNodeCollectionViewItem(nibName: NSNib.Name("SoundNodeCollectionViewItem"), bundle: Bundle.main)
        
        // Test
        self.nodes.append(SoundNode(name: "Nodo Demo", position: NSPoint(x:100.0, y:100.0)))
        self.nodes.append(SoundNode(name: "440Hz", position: NSPoint(x:100.0, y:225.0)))
        self.nodes.append(SoundNode(name: "440Hz", position: NSPoint(x:1000.0, y:600.0)))
        
        // Test
//        let demoNode = SoundNodeView(frame: NSRect(x: 100.0, y: 100.0, width: 120.0, height: 80.0))
//        demoNode.nameLabel?.stringValue = "Nodo 1"
//        self.scrollView?.documentView?.addSubview(
//            demoNode
//        )
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
}

/**
 Visualizzazione dei nodi.
 */
extension SoundBoardViewController: NSCollectionViewDelegate, NSCollectionViewDataSource, SoundBoardCollectionLayoutDelegate {
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
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: SoundBoardCollectionLayout, frameForItemAt indexPath: IndexPath) -> NSRect {
        if (!self.nodes.indices.contains(indexPath.item)) {
            return NSRect.zero
        }
        
        let node = self.nodes[indexPath.item]
        self.nodeItemTemplateView?.node = node
        return NSRect(
            origin: node.position,
            size: self.nodeItemTemplateView!.view.fittingSize
        )
    }
    
    func calculateBoardContentSize() -> NSSize {
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
        
        self.scrollView!.documentView?.frame.size = size
        
        return size
    }
    
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
