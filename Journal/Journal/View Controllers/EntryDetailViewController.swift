//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/26/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    var entry: Entry?
    var wasEdited: Bool = false
    var entryController: EntryController?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var entryTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    @objc func save() {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = entryTextView.text else { return }
        
        let selectedMood = moodControl.selectedSegmentIndex
        let mood = Mood.allCases[selectedMood]
        let timestamp = NSDate.now
        
        Entry(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
    }
    
    func updateViews() {
        
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .neutral
        }
        
        moodControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodControl.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        moodControl.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if wasEdited == true {
            guard let title = titleTextField.text,
                !title.isEmpty,
                let entry = entry else {
                    return
            }
            
            let bodyText = entryTextView.text
            entry.title = title
            entry.bodyText = bodyText
            let selectedMood = moodControl.selectedSegmentIndex
            entry.mood = Mood.allCases[selectedMood].rawValue
            
            entryController?.put(entry: entry, completion: { (_) in })
            
            do {
            try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
}
