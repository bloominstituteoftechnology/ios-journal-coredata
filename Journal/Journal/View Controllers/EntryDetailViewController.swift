//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Dahna on 4/22/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var moodSegementedController: UISegmentedControl!
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    
    
    var entry: Entry?
    var wasEdited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateViews()
        
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        
        entryTextField.text = entry.title
        entryTextField.isUserInteractionEnabled = isEditing
        
        entryTextView.text = entry.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let chosenMood = entry.mood {
            mood = Mood(rawValue: chosenMood)!
        } else {
            mood = .c
        }
        
        moodSegementedController.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodSegementedController.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true { wasEdited = true }
        entryTextField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        moodSegementedController.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = entryTextField.text,
                !title.isEmpty,
                let entry = entry else {
                    return
            }
            
            entry.title = title
            entry.bodyText = entryTextView.text
            let moodIndex = moodSegementedController.selectedSegmentIndex
            entry.mood = Mood.allCases[moodIndex].rawValue
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }

    }
    
}
