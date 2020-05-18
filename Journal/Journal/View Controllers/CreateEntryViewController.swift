//
//  ViewController.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

protocol EntryDelegate {
    func entryWasCreated(_ entry: Entry)
}

class ViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeValue(sender: segmentedControl)
    }
    
    var delegate: EntryDelegate?
    
    
    func changeValue(sender: UISegmentedControl) {
        let i = sender.selectedSegmentIndex
            if i == 0 {
                segmentedControl.selectedSegmentTintColor = UIColor.green
            } else if i == 1 {
                segmentedControl.selectedSegmentTintColor = UIColor.brown
            } else if i == 2 {
                segmentedControl.selectedSegmentTintColor = UIColor.orange
            }
    }
    
    @IBAction func cancelCreate(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func saveJournal(_ sender: UIButton) {
        guard let title = titleTextField.text,
            let body = entryTextView.text,
            !title.isEmpty,
            !body.isEmpty else { return }
        
        
        let selectedMood = segmentedControl.selectedSegmentIndex
        
        let mood = Mood.allCases[selectedMood]
        
        Entry(title: title,
              bodyText: body,
              mood: mood)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    @IBAction func sControl(_ sender: UISegmentedControl) {
        changeValue(sender: sender)
    }
}

