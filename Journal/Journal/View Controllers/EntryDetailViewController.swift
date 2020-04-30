//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Juan M Mariscal on 4/28/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    var wasEdited = false
    var entryController: EntryController?
    
    // MARK: IBOutlets
    @IBOutlet weak var journalTitleText: UITextField!
    @IBOutlet weak var journalEntryTextView: UITextView!
    @IBOutlet weak var moodSelectControl: UISegmentedControl!    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = journalTitleText.text,
                !title.isEmpty,
                let entry = entry else {
                return
            }
            let journal = journalEntryTextView.text
            entry.title = title
            entry.bodyText = journal
            let priorityIndex = moodSelectControl.selectedSegmentIndex
            entry.mood = Mood.allCases[priorityIndex].rawValue
            entryController?.sendEntryToServer(entry: entry)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    // MARK: Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        journalTitleText.isUserInteractionEnabled = editing
        journalEntryTextView.isUserInteractionEnabled = editing
        moodSelectControl.isUserInteractionEnabled = editing
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
    
    // MARK: Private
    
    private func updateViews() {
        journalTitleText.text = entry?.title
        journalTitleText.isUserInteractionEnabled = isEditing
        
        journalEntryTextView.text = entry?.bodyText
        journalEntryTextView.isUserInteractionEnabled = isEditing

        let priority: Mood
        if let mood = entry?.mood {
            priority = Mood(rawValue: mood)!
        } else {
            priority = .happy
        }
        moodSelectControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: priority) ?? 1
        moodSelectControl.isUserInteractionEnabled = isEditing
    }

}
