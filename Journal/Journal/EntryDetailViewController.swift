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
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var moodSegementedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = entryTextField.text,
                !title.isEmpty,
                let bodyText = descriptionTextView.text,
                !bodyText.isEmpty,
                let entry = entry else { return }
            entry.title = title
            entry.bodyText = bodyText
            let moodIndex = moodSegementedController.selectedSegmentIndex
            entry.mood = Mood.allCases[moodIndex].rawValue
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        entryTextField.isUserInteractionEnabled = editing
        descriptionTextView.isUserInteractionEnabled = editing
        moodSegementedController.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        entryTextField.text = entry?.title
        entryTextField.isUserInteractionEnabled = isEditing
        
        descriptionTextView.text = entry?.bodyText
        descriptionTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .neutral
        }
        moodSegementedController.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodSegementedController.isUserInteractionEnabled = isEditing
    }
    
}
