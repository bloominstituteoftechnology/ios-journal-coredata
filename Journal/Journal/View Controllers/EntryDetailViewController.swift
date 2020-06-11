//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Morgan Smith on 4/25/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    
    @IBOutlet weak var journalMood: UISegmentedControl!
    
    @IBOutlet weak var journalTitle: UITextField!
    
    @IBOutlet weak var journalText: UITextView!
    
    var entry: Entry?
    var wasEdited: Bool = false
    var entryController: EntryController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateViews()
    }
    
    func updateViews() {
        journalTitle.text = entry?.title
        journalText.text = entry?.bodyText
        
        journalTitle.isUserInteractionEnabled = isEditing
        journalMood.isUserInteractionEnabled = isEditing
        
        let mood: EntryMood
        if let entryMood = entry?.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .😶
        }
        
        journalMood.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood) ?? 1
        journalMood.isUserInteractionEnabled = isEditing
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if editing == true {
            wasEdited = true
        }
        journalTitle.isUserInteractionEnabled = editing
        journalMood.isUserInteractionEnabled = editing
        journalText.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited { guard let title = journalTitle.text, !title.isEmpty, let entry = entry else {
            return
            }
            let bodyText = journalText.text
            entry.title = title
            entry.bodyText = bodyText
            let selectedMood = journalMood.selectedSegmentIndex
            entry.mood = EntryMood.allCases[selectedMood].rawValue
            
            entryController?.sendEntryToServer(entry: entry)
            
            do {
                try CoreDataStack.shared.mainContext.save()
                navigationController?.dismiss(animated: true, completion: nil)
            } catch {
                NSLog("Error saving manage object contedxt: \(error)")
            }
        }
    }
    
}
