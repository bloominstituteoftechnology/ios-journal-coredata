//
//  ViewController.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var entryController: EntryContoller?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeValue(sender: segmentedControl)
    }
    
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
        
        let entry = Entry(title: title,
              bodyText: body,
              mood: mood.rawValue)
         entryController?.sendEntryToServer(entry: entry, completion: { _ in })
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    @IBAction func segmentedValueChange(_ sender: UISegmentedControl) {
        changeValue(sender: sender)
    }
}

