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
    var isRightSidebarShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        
        // Nascondo la rightSidebar
        self.rightSideBarXConstraint.constant = -self.rightSideBarView!.frame.size.width
        self.isRightSidebarShown = false
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
