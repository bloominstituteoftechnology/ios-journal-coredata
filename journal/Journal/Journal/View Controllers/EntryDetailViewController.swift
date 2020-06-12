//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Ian French on 6/10/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    
    @IBOutlet weak var entryDetailTextView: UITextView!
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    var entryController: EntryController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    var entry: Entry?
    var wasEdited: Bool = false
      
    override func setEditing(_ editing: Bool, animated: Bool) {
       
        super.setEditing(editing, animated: animated)
        if editing{
            wasEdited = true
        }
        
        entryTitleTextField.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        entryDetailTextView.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited{
            guard let title = entryTitleTextField.text, !title.isEmpty,
                let entryText = entryDetailTextView.text, !entryText.isEmpty,
                let entry = entry
                else { return }
            let moodIndex = moodSegmentedControl.selectedSegmentIndex
            
            entry.title = title
            entry.bodyText = entryText
            entry.mood = Mood.allCases[moodIndex].rawValue

            entryController?.sendEntryToServer(entry: entry)

            do{
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    
    
    
    private func updateViews() {
        entryTitleTextField.text = entry?.title
        entryTitleTextField.isUserInteractionEnabled = isEditing

        entryDetailTextView.text = entry?.bodyText
        entryDetailTextView.isUserInteractionEnabled = isEditing
        
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
