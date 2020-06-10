//
//  EntryDetailViewController.swift
//  journal-coredata
//
//  Created by Rob Vance on 6/5/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // Mark: - Properties
    var entry: Entry?
    var wasEdited = false
    var entryController: EntryController?
    
    // Mark: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodController: UISegmentedControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = titleTextField.text, !title.isEmpty,
                let entry = entry else { return}
            entry.title = title
            entry.bodyText = entryTextView.text
            let moodIndex = moodController.selectedSegmentIndex
            entry.mood = MoodPriority.allCases[moodIndex].rawValue
            entryController?.sendEntryToServer(entry: entry)
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true}
        titleTextField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        moodController.isUserInteractionEnabled = editing
        
    }
    
    
    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        let mood: MoodPriority
        if let moodPriority = entry?.mood {
            mood = MoodPriority(rawValue: moodPriority)!
        } else {
            mood = .😐
        }
        moodController.selectedSegmentIndex = MoodPriority.allCases.firstIndex(of: mood) ?? 1
        moodController.isUserInteractionEnabled = isEditing
    }
}
