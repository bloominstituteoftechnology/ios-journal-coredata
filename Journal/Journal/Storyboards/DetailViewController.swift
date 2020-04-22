//
//  DetailEntryViewController.swift
//  Journal
//
//  Created by Mark Poggi on 4/21/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    var entry: Entry?
    var wasEdited = false
    var entryController = EntryController()
    

    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodEmojiControl: UISegmentedControl!
    
    
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
                !title.isEmpty,
                let bodyText = entryTextView.text,
                !bodyText.isEmpty,
                let entry = entry else {
                    return
            }
            
            entry.title = title
            entry.bodyText = bodyText
            entry.timestamp = Date()
            let moodPriority = moodEmojiControl.selectedSegmentIndex
            entry.mood = MoodPriority.allCases[moodPriority].rawValue
            entryController.sendEntryToServer(entry: entry)

            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("error savng managed object context: \(error)")
            }
        }
    }
    
    // MARK: - Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        moodEmojiControl.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
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
            mood = .neutral
            
        }
        moodEmojiControl.selectedSegmentIndex = MoodPriority.allCases.firstIndex(of: mood) ?? 1
        moodEmojiControl.isUserInteractionEnabled = isEditing
        
    }
}
