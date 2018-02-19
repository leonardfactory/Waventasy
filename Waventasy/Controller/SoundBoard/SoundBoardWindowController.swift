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

private enum SoundNodeMenuItem: String {
    case none = ""
    case frequency = "FrequencyItem"
    case harmonic = "HarmonicItem"
}

class SoundBoardWindowController: NSWindowController {
    
    @IBOutlet weak var sidebarControl:NSSegmentedControl?
    @IBOutlet weak var popUpAddButton: NSPopUpButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.setupAddButtonMenu()
        
        self.window?.makeFirstResponder(self.window!.contentViewController)
    }
    
    // Prepariamo la view per il menu di aggiunta
    private func setupAddButtonMenu() {
        let menu = NSMenu()
        
        let mainItem = NSMenuItem(title:"", action:nil, keyEquivalent:"")
        mainItem.image = NSImage(named: NSImage.Name.addTemplate)
        mainItem.identifier = NSUserInterfaceItemIdentifier(rawValue: SoundNodeMenuItem.none.rawValue)
        menu.addItem(mainItem)
        
        let frequencyItem = NSMenuItem(title: "Frequenza", action: nil, keyEquivalent: "f")
        frequencyItem.image = soundNodeSwatchImage(fromType: SoundNode.NodeType.frequency)
        frequencyItem.identifier = NSUserInterfaceItemIdentifier(rawValue: SoundNodeMenuItem.frequency.rawValue)
        menu.addItem(frequencyItem)
        
        let harmonicItem = NSMenuItem(title: "Armonica", action: nil, keyEquivalent: "a")
        harmonicItem.image = soundNodeSwatchImage(fromType: SoundNode.NodeType.harmonic)
        harmonicItem.identifier = NSUserInterfaceItemIdentifier(rawValue: SoundNodeMenuItem.harmonic.rawValue)
        menu.addItem(harmonicItem)
        
        self.popUpAddButton.imagePosition = .imageOnly
        self.popUpAddButton.menu = menu
    }
    
    @IBAction func addNode(_ sender: NSPopUpButton) {
        let viewController = self.window?.contentViewController as! SoundBoardViewController
        let selectedItem = SoundNodeMenuItem(rawValue: (sender.selectedItem?.identifier)!.rawValue) ?? SoundNodeMenuItem.none
        
        switch (selectedItem) {
        case .frequency: viewController.addSoundNode(type: SoundNode.NodeType.frequency)
        case .harmonic: viewController.addSoundNode(type: SoundNode.NodeType.harmonic)
        default: return
        }
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
