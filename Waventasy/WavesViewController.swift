//
//  WavesViewController.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 13/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa
import AudioKit

class WavesViewController: NSViewController {
    
    @IBOutlet weak var tableView:NSTableView?
    
    @IBOutlet weak var playButton:NSButton?
    @IBOutlet weak var stopButton:NSButton?
    
    fileprivate var harmonics:[Harmonic] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.harmonics = [
            Harmonic(octave: 1, amplitude: 2, attack: 0.4, decay: 0.1, sustain: 0.3, release: 0.2),
            Harmonic(octave: 2, amplitude: 1.5, attack: 0.4, decay: 0.1, sustain: 0.3, release: 0.2),
        ]
        
        self.playButton?.target = self
        self.playButton?.action = #selector(startPlaying)
    }
    
    @objc func startPlaying() {
        print("start playing")
        
        let mixer = (SoundBuilder(frequency: 440).withHarmonics(harmonics: self.harmonics))

        AudioKit.output = mixer
        AudioKit.start()

        mixer.play()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

enum MissingColumnError: Error {
    case identifierMissing
}

/**
    Display dell'elenco delle ottave.
 */
extension WavesViewController : NSTableViewDataSource, NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let OctaveCell = "OctaveCellId"
        static let AttackCell = "AttackCellId"
        static let DecayCell = "DecayCellId"
        static let SustainCell = "SustainCellId"
        static let ReleaseCell = "ReleaseCellId"
    }
    
    fileprivate enum ColumnIdentifiers {
        static let OctaveColumn = "OctaveColumn"
        static let AttackColumn = "AttackColumn"
        static let DecayColumn = "DecayColumn"
        static let SustainColumn = "SustainColumn"
        static let ReleaseColumn = "ReleaseColumn"
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.harmonics.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let harmonic = self.harmonics[row] as Harmonic? else {
            print("No harmonic found")
            return nil
        }
        
        guard let columnId = tableColumn?.identifier.rawValue as String? else {
            print("Error while displaying column missing identifier")
            return nil
        }
        
        switch (columnId) {
        case ColumnIdentifiers.AttackColumn:
            return doubleCellWithIdentifier(ColumnIdentifiers.AttackColumn, value: harmonic.attack);
        case ColumnIdentifiers.DecayColumn:
            return doubleCellWithIdentifier(ColumnIdentifiers.DecayColumn, value: harmonic.decay);
        case ColumnIdentifiers.OctaveColumn:
            return intCellWithIdentifier(ColumnIdentifiers.OctaveColumn, value: harmonic.octave);
        case ColumnIdentifiers.SustainColumn:
            return doubleCellWithIdentifier(ColumnIdentifiers.SustainColumn, value: harmonic.sustain);
        case ColumnIdentifiers.ReleaseColumn:
            return doubleCellWithIdentifier(ColumnIdentifiers.ReleaseColumn, value: harmonic.release);
            
        default:
            print("Error while displaying column missing identifier")
            return nil
        }
    }
    
    /**
        Mostra una TableCellView con un valore double.
    */
    func doubleCellWithIdentifier(_ identifier: String, value: Double) -> NSView? {
        if let cell = tableView?.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = String(format:"%.2f", value)
            return cell
        }
        return nil
    }
    
    func intCellWithIdentifier(_ identifier: String, value: Int) -> NSView? {
        if let cell = tableView?.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = String(format:"%d", value)
            return cell
        }
        return nil
    }
}
