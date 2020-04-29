//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Claudia Contreras on 4/22/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet var journalEntryTextField: UITextField!
    @IBOutlet var journalTextView: UITextView!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = journalEntryTextField.text, !title.isEmpty,
            let text = journalTextView.text, !text.isEmpty else { return }
        
        let currentDateTime = Date()
        let moodEntry = moodSegmentedControl.selectedSegmentIndex
        let moodSelection = MoodSelection.allCases[moodEntry]

        let entry = Entry(identifier: "", title: title, bodyText: text, timestamp: currentDateTime, mood: moodSelection, context: CoreDataStack.shared.mainContext)
        
        entryController?.sendEntryToServer(entry: entry)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving manage object context: \(error)")
        }
    }
    

}

