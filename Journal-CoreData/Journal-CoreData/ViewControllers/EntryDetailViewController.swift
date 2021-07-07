//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Sameera Roussi on 5/27/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    
    // MARK: - Properties
    var entryController: EntryController?
    var entry: Entry?
    
    // MARK: - View States
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Are we doing a new entry or an update?
        updateViews()
    }
    
    
    // MARK: - View Functions
    
    func updateViews() {
        guard let entry = self.entry, // We are unwrapping the entry here
            isViewLoaded else { return }
        
        title = entry.title ?? "New Entry"
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
        
        if let entryMood = entry.mood,
            let mood = Moods(rawValue: entryMood) {
            
            moodSegmentControl.selectedSegmentIndex = Moods.allMoods.firstIndex(of: mood) ?? 1
        }
            
    }

    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // Make sure there's a title to the entry
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = bodyTextView.text, !bodyText.isEmpty else { return }
        
        let moodIndex = moodSegmentControl.selectedSegmentIndex
        let mood = Moods.allMoods[moodIndex]
        
        if let entry = entry {
            entry.title = title
            entry.bodyText = bodyText
            entry.mood = mood.rawValue
            // Update an exsiting entry
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
            
        } else {
            let entry = Entry(title: title, bodyText: bodyText, mood: mood)
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood.rawValue)
        }
        
        // Go back to the tableview
        _ = navigationController?.popViewController(animated: true)
    }

}
