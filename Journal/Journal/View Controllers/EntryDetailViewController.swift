//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Thomas Dye on 4/30/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entryController: EntryController?
        
        var entry: Entry?
        var wasEdited: Bool = false
        
        @IBOutlet weak var titleTextField: UITextField!
        @IBOutlet weak var notesTextView: UITextView!
        @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.rightBarButtonItem = editButtonItem
            updateViews()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            guard let entry = entry else { return }
            
            if wasEdited {
                if let title = titleTextField.text,
                    !title.isEmpty,
                    let notes = notesTextView.text,
                    !notes.isEmpty {
                    
                    entry.title = title
                    entry.bodyText = notes
                    
                    let moodIndex = moodSegmentedControl.selectedSegmentIndex
                    entry.mood = Mood.allCases[moodIndex].rawValue
                    
                    entryController?.sendEntryToServer(entry: entry, completion: { _ in })
                    
                    let context = CoreDataStack.shared.container.newBackgroundContext()
                    
                    do {
                        try CoreDataStack.shared.save(context: context)
                        navigationController?.dismiss(animated: true)
                    } catch {
                        NSLog("Error saving Entry to context: \(error)")
                        context.reset()
                    }
                }
            }
        }
        
        override func setEditing(_ editing: Bool, animated: Bool) {
            super.setEditing(editing, animated: animated)
            if editing { wasEdited = true }
            
            titleTextField.isUserInteractionEnabled = editing
            notesTextView.isUserInteractionEnabled = editing
            moodSegmentedControl.isUserInteractionEnabled = editing
            
            navigationItem.hidesBackButton = editing
        }
        
        func updateViews() {
            titleTextField.text = entry?.title
            notesTextView.text = entry?.bodyText
            
            switch entry?.mood {
            case Mood.sad.rawValue:
                moodSegmentedControl.selectedSegmentIndex = 0
            case Mood.neutral.rawValue:
                moodSegmentedControl.selectedSegmentIndex = 1
            case Mood.happy.rawValue:
                moodSegmentedControl.selectedSegmentIndex = 2
            default:
                break
            }
            
            titleTextField.isUserInteractionEnabled = isEditing
            notesTextView.isUserInteractionEnabled = isEditing
            moodSegmentedControl.isUserInteractionEnabled = isEditing
        }
        
    }
