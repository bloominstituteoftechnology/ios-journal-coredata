//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Claudia Contreras on 4/24/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var journalTitle: UITextField!
    @IBOutlet var journalMoodSelector: UISegmentedControl!
    @IBOutlet var journalTextView: UITextView!
    
    // MARK: - Properties
    var entry: Entry?
    var wasEdited = false
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [editButtonItem]
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let entry = entry else { return }
        
        if wasEdited {
            guard let title = journalTitle.text, !title.isEmpty,
                let text = journalTextView.text, !text.isEmpty else { return }
            entry.title = title
            entry.bodyText = text
            
            let moodEntry = journalMoodSelector.selectedSegmentIndex
            let moodSelection = MoodSelection.allCases[moodEntry]
            entry.mood = moodSelection.rawValue
            
            entryController?.sendEntryToServer(entry: entry)
            
            do {
                try CoreDataStack.shared.mainContext.save()
                navigationController?.dismiss(animated: true, completion: nil)
            } catch {
                NSLog("Error saving manage object context: \(error)")
            }
        }
    }
    
    // MARK: - Functions
    @objc func editTapped() {
        
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        
        journalTitle.text = entry.title
        journalTextView.text = entry.bodyText
        
        switch entry.mood {
        case MoodSelection.sad.rawValue:
            journalMoodSelector.selectedSegmentIndex = 2
        case MoodSelection.neutral.rawValue:
            journalMoodSelector.selectedSegmentIndex = 1
        default:
            journalMoodSelector.selectedSegmentIndex = 0
        }
        
        journalMoodSelector.isUserInteractionEnabled = isEditing
        journalTitle.isUserInteractionEnabled = isEditing
        journalTextView.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditing {
            wasEdited = true
        }
        journalMoodSelector.isUserInteractionEnabled = editing
        journalTitle.isUserInteractionEnabled = editing
        journalTextView.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
