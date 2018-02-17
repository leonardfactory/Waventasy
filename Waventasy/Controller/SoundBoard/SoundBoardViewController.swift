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
        
        self.nodeItemTemplateView = SoundNodeCollectionViewItem(nibName: NSNib.Name("SoundNodeCollectionViewItem"), bundle: Bundle.main)
        
        // Test
        self.nodes.append(SoundNode(name: "Nodo Demo", position: NSPoint(x:100.0, y:100.0)))
        self.nodes.append(SoundNode(name: "440Hz", position: NSPoint(x:100.0, y:225.0)))
        
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
}
