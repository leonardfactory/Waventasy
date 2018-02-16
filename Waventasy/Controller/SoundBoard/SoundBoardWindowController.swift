//
//  SoundBoardWindowController.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 16/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

private enum SidebarToolbarSegment: Int {
    case none = -1
    case left = 0
    case right = 1
}

class SoundBoardWindowController: NSWindowController {
    
    @IBOutlet weak var sidebarControl:NSSegmentedControl?

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    // Inviamo il comando al ViewController per mostrare e nascondere
    // la sidebar.
    @IBAction func toggleSidebar(_ sender: NSSegmentedControl) {
        let viewController = self.window?.contentViewController as! SoundBoardViewController
        let selectedSegment = SidebarToolbarSegment(rawValue: sender.selectedSegment) ?? SidebarToolbarSegment.none
        
        switch (selectedSegment) {
        case .left: viewController.toggleLeftSidebar()
        case .right: viewController.toggleRightSidebar()
        case .none: return
        }
    }
}
