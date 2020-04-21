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
