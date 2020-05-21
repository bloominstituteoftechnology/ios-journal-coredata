//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Nonye on 5/19/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry?
    var wasEdited: Bool = false
    var entryController: EntryController?
    
       // MARK: - OUTLETS
       
       @IBOutlet weak var journalEntryTitleText: UITextField!
       @IBOutlet weak var journalTextView: UITextView!
       @IBOutlet weak var moodControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
        // Do any additional setup after loading the view.
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        wasEdited = true
        
        journalEntryTitleText.isUserInteractionEnabled = editing
        journalTextView.isUserInteractionEnabled = editing
        moodControl.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }

    func updateViews() {
        guard let entry = entry else { return }
        
        guard let entryMood = entry.mood,
            let mood = Mood(rawValue: entryMood),
            let moodIndex = Mood.allCases.firstIndex(of: mood) else { return }
        
        journalEntryTitleText.text = entry.title
        journalEntryTitleText.isUserInteractionEnabled = isEditing
        
        journalTextView.text = entry.bodyText
        journalTextView.isUserInteractionEnabled = isEditing
        
        moodControl.selectedSegmentIndex = moodIndex
        moodControl.isUserInteractionEnabled = isEditing
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let journalTitle = journalEntryTitleText.text,
                !journalTitle.isEmpty,
                let entry = entry else { return }
            
            //TODO
        }
    }
}
