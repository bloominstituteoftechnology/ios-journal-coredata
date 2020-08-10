//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Dojo on 8/9/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    private var wasEdited: Bool = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = titleTextField.text,
                !title.isEmpty,
                let bodyText = bodyTextView.text,
                !bodyText.isEmpty,
                let entry = entry else { return }
            entry.title = title
            entry.bodyText = bodyText
            let moodIndex = moodSegmentedControl.selectedSegmentIndex
            entry.mood = Mood.allCases[moodIndex].rawValue
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        titleTextField.isUserInteractionEnabled = editing
        bodyTextView.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        bodyTextView.text = entry?.bodyText
        bodyTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .neutral
        }
        moodSegmentedControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodSegmentedControl.isUserInteractionEnabled = isEditing
    }
    
}
