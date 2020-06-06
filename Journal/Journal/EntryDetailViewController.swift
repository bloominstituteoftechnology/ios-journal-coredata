//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Josh Kocsis on 6/5/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var entryTextView: UITextView!
    
    var entry: Entry?
    var wasEdited = false
    
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
               let entryText = entryTextView.text
               entry.title = title
               entry.bodyText = entryText
               let moodIndex = moodSegmentedControl.selectedSegmentIndex
               entry.mood = Mood.allCases[moodIndex].rawValue
               do {
                   try CoreDataStack.shared.mainContext.save()
               } catch {
                   NSLog("Error saving managed object context: \(error)")
               }
           }
       }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .neutral
        }
        moodSegmentedControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
               moodSegmentedControl.isUserInteractionEnabled = isEditing
    }
}
