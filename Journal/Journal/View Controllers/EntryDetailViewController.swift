//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Hunter Oppel on 4/21/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var entry: Entry?
    var wasEdited = false
    var entryController: EntryController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodController: UISegmentedControl!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = titleTextField.text,
                let entry = entry else { return }
            
            entry.title = title
            entry.bodyText = entryTextView.text
            let moodIndex = moodController.selectedSegmentIndex
            entry.mood = MoodProperties.allCases[moodIndex].rawValue
            // Uncomment this if you want a "Last Edited" timestamp instead of inital creation timestamp
            // entry.timestamp = Date()
            do {
                try CoreDataStack.shared.mainContext.save()
                entryController?.sendEntryToServer(entry: entry)
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
        moodController.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    // MARK: - Private functions
    
    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        let mood: MoodProperties
        if let moodProperties = entry?.mood {
            mood = MoodProperties(rawValue: moodProperties)!
        } else {
            mood = .neutral
        }
        moodController.selectedSegmentIndex = MoodProperties.allCases.firstIndex(of: mood) ?? 1
        moodController.isUserInteractionEnabled = isEditing
    }
}
