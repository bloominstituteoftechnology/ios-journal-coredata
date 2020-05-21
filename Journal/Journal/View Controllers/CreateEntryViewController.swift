//
//  ViewController.swift
//  Journal
//
//  Created by Harmony Radley on 5/18/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    var entryController: EntryController?
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField! // title
    @IBOutlet weak var bodyTextView: UITextView! // bodyText
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        guard let bodyText = bodyTextView.text, !bodyText.isEmpty else { return }
        
        let timestamp = Date()
        
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = MoodPriority.allCases[moodIndex]
        
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood)
        entryController?.sendEntryToServer(entry: entry)
        
        // Saving
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
    }
}

