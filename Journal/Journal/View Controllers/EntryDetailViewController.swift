//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/28/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    //MARK: - IBOutlets and properties -
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
    @IBOutlet var notesTextView: UITextView!
    
    var entryController: EntryController?
    var entry: Entry?
    var wasEdited: Bool = false
    
    //MARK: - Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        
        titleTextField.text = entry.title
        notesTextView.text = entry.bodyText
        switch entry.mood {
        case Mood.sad.rawValue:
            moodSegmentedControl.selectedSegmentIndex = 0
        case Mood.happy.rawValue:
            moodSegmentedControl.selectedSegmentIndex = 2
        default:
            moodSegmentedControl.selectedSegmentIndex = 1
        }
        
        titleTextField.isUserInteractionEnabled = isEditing
        moodSegmentedControl.isUserInteractionEnabled = isEditing
        notesTextView.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            wasEdited = true
        }
        
        titleTextField.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        notesTextView.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let entry = entry else { return }
        
        if wasEdited {
            
            guard let title = titleTextField.text,
                let notes = notesTextView.text,
                !title.isEmpty,
                !notes.isEmpty else { return }
            
            let selectedMoodIndex = moodSegmentedControl.selectedSegmentIndex
            if selectedMoodIndex == 0 {
                self.entry?.mood = Mood.sad.rawValue
            } else if selectedMoodIndex == 1 {
                self.entry?.mood = Mood.neutral.rawValue
            } else if selectedMoodIndex == 2 {
                self.entry?.mood = Mood.happy.rawValue
            }
            self.entry?.title = title
            self.entry?.bodyText = notes
        }
        
        do {
            try CoreDataStack.shared.mainContext.save()
        }  catch {
            NSLog("Could not save becuase: \(error)")
        }
        
        entryController?.sendEntryToServer(entry: entry, completion: { _ in })
        
    }

} //End of class
