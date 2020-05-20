//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Dahna on 5/19/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var entry: Entry?
    var wasEdited: Bool = false
    var entryController: EntryController?
    
    // MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var bodyTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        
        updateViews()
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        
        titleTextField.text = entry.title
        titleTextField.isUserInteractionEnabled = isEditing
        bodyTextView.text = entry.bodyText
        bodyTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let chosenMood = entry.mood {
            mood = Mood(rawValue: chosenMood)!
        } else {
            mood = .neutral
        }
        
        moodControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodControl.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true { wasEdited = true }
        titleTextField.isUserInteractionEnabled = editing
        bodyTextView.isUserInteractionEnabled = editing
        moodControl.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = titleTextField.text,
                !title.isEmpty,
                let entry = entry else { return }
            
            entry.title = title
            entry.bodyText = bodyTextView.text
            let moodIndex = moodControl.selectedSegmentIndex
            entry.mood = Mood.allCases[moodIndex].rawValue
            entryController?.sendEntryToServer(entry: entry)
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                CoreDataStack.shared.mainContext.reset()
                NSLog("Error saving managed object context: \(error)")
            }
        }
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
