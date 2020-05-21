//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Harmony Radley on 5/19/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    var entry: Entry?
    var entryController: EntryController?
    var wasEdited = false
    
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
            guard let title = titleTextField.text,
                !title.isEmpty,
                let entry = entry else { return }

            entry.title = title
            entry.bodyText = entryTextView.text
            let moodIndex = moodController.selectedSegmentIndex
            entry.mood = MoodPriority.allCases[moodIndex].rawValue
            entryController?.sendEntryToServer(entry: entry)

            do {
                try CoreDataStack.shared.save()
               
            } catch {
                NSLog("Error saving managed object context (during entry edit): \(error)")
            }
        }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        moodController.isUserInteractionEnabled = editing
        
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
             mood = .😐
         }
         moodController.selectedSegmentIndex = MoodPriority.allCases.firstIndex(of: mood) ?? 1
         moodController.isUserInteractionEnabled = isEditing
     }


}
