//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Matthew Martindale on 4/21/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if let title = titleTextField.text,
            !title.isEmpty,
            let notes = notesTextView.text,
            !notes.isEmpty {
            
            let selectedMood = moodSegmentedControl.selectedSegmentIndex
            let mood = Mood.allCases[selectedMood]
            
            let entry = Entry(title: title,
                  bodyText: notes,
                  mood: mood,
                  context: CoreDataStack.shared.mainContext)
            
            entryController?.sendEntryToServer(entry: entry, completion: { _ in })
            
            do {
                try CoreDataStack.shared.mainContext.save()
                navigationController?.dismiss(animated: true)
            } catch {
                NSLog("Error saving Entry to context: \(error)")
                CoreDataStack.shared.mainContext.reset()
            }
        }
    }
}

