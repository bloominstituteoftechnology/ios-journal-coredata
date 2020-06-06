//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Kenneth Jones on 6/5/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    var wasEdited = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var bodyTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        
        updateViews()
    }
    
    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        bodyTextView.text = entry?.bodyText
        bodyTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .happy
        }
        
        moodControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodControl.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        titleTextField.isUserInteractionEnabled = editing
        bodyTextView.isUserInteractionEnabled = editing
        moodControl.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = titleTextField.text,
                !title.isEmpty,
                let entry = entry else {
                return
            }
            let body = bodyTextView.text
            entry.title = title
            entry.bodyText = body
            let moodIndex = moodControl.selectedSegmentIndex
            entry.mood = Mood.allCases[moodIndex].rawValue
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
}
