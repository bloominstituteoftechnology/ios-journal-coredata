//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Lambda_School_loaner_226 on 4/28/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import CoreData

class CreateEntryViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let entry = entryTextField.text,
                !entry.isEmpty,
                let notes = notesTextView.text,
                !notes.isEmpty else {
                return
            }
            let moodIndex = moodControl.selectedSegmentIndex
            let mood = EntryMood.allCases[moodIndex]
        
            Entry(title: entry, bodyText: notes, mood: mood)
        
            do {
                try CoreDataStack.shared.mainContext.save()
                navigationController?.dismiss(animated: true, completion: nil)
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    
    
    
    
}
