//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Chris Dobek on 4/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    
    // MARK: - Properties
    var journalController: JournalController?
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
            
        let entry = Entry(title: title, bodyText: entryTextView.text, mood: mood)
        journalController?.sendEntryToServer(entry: entry)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Failed to save coredata context: \(error)")
            return
        }

        navigationController?.dismiss(animated: true, completion: nil)
    }


}

