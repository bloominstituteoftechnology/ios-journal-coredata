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
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodController: UISegmentedControl!

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
