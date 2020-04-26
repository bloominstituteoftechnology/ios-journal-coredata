//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Matthew Martindale on 4/23/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
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
        if wasEdited == true {
            if let title = titleTextField.text,
                !title.isEmpty,
                let notes = notesTextView.text,
                !notes.isEmpty {
                
                let selectedMood = moodSegmentedControl.selectedSegmentIndex
                let mood = Mood.allCases[selectedMood]
                
                Entry(title: title,
                      bodyText: notes,
                      mood: mood,
                      context: CoreDataStack.shared.mainContext)
                
                do {
                    try CoreDataStack.shared.mainContext.save()
                    navigationController?.dismiss(animated: true)
                } catch {
                    NSLog("Error saving Entry to context: \(error)")
                    CoreDataStack.shared.mainContext.reset()
                }
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            wasEdited = true
            
        }
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
