//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Kelson Hartle on 5/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    var wasEdited = false
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var emojiSegmentedControl: UISegmentedControl!
    @IBOutlet weak var textEntryTextView: UITextView!
    
    
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
                let entry = entry else { return }
            
            let textEntry = textEntryTextView.text
            entry.title = title
            entry.bodyText = textEntry
            let priorityIndex = emojiSegmentedControl.selectedSegmentIndex
            entry.mood = Mood.allCases[priorityIndex].rawValue
            
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
        emojiSegmentedControl.isUserInteractionEnabled = editing
        textEntryTextView.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    
    private func updateViews() {
        
        
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        textEntryTextView.text = entry?.bodyText
        textEntryTextView.isUserInteractionEnabled = isEditing
        
        let priority: Mood
        if let taskPriority = entry?.mood {
            priority = Mood(rawValue: taskPriority)!
        } else {
            priority = .ok
        }
        
        emojiSegmentedControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: priority) ?? 1
        emojiSegmentedControl.isUserInteractionEnabled = isEditing
    }
    

}
