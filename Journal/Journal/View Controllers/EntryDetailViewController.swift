//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Chris Dobek on 4/21/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    var entry: Entry?
    var wasEdited = false
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = titleTextField.text,
                !title.isEmpty,
                let entry = entry else {
                    return
            }
            
            let bodyText = entryTextView.text
            entry.title = title
            entry.bodyText = bodyText
            let moodIndex = moodControl.selectedSegmentIndex
            entry.mood = EntryMood.allCases[moodIndex].rawValue
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    // MARK: - Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        moodControl.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    // MARK: - Actions
    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        
        let mood: EntryMood
        if let entryMood = entry?.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .neutral
        }
        
        moodControl.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood) ?? 1
        moodControl.isUserInteractionEnabled = isEditing
    }
}
