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
