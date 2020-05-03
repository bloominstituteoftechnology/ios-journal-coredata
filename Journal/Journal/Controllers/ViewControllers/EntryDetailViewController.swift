//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Lambda_School_loaner_226 on 5/2/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var moodDetailControl: UISegmentedControl!
    @IBOutlet weak var journalDetailTextField: UITextField!
    @IBOutlet weak var journalDetailTextView: UITextView!
    
    var entry: Entry?
    var wasEdited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
    }
    
    func updateViews() {
        journalDetailTextField.text = entry?.title
        journalDetailTextView.text = entry?.bodyText
        
        journalDetailTextField.isUserInteractionEnabled = isEditing
        journalDetailTextView.isUserInteractionEnabled = isEditing
        moodDetailControl.isUserInteractionEnabled = isEditing
        
        let mood: EntryMood
        if let moodValue = entry?.mood {
            mood = EntryMood(rawValue: moodValue)!
        } else {
            mood = .neutral
        }
        
        moodDetailControl.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood) ?? 1
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(isEditing, animated: true)
        switch wasEdited {
        case editing == true:
            journalDetailTextField.isUserInteractionEnabled = editing
            journalDetailTextField.isUserInteractionEnabled = editing
            moodDetailControl.isUserInteractionEnabled = editing
            navigationItem.hidesBackButton = editing
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let journalTitle = journalDetailTextField.text, !journalTitle.isEmpty,
                let entry = entry else { return }
            
            entry.title = title
            entry.bodyText = journalDetailTextView.text
            let moodController = moodDetailControl.selectedSegmentIndex
            entry.mood = EntryMood.allCases[moodController].rawValue
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context  \(error)")
            }
        }
    }
}
