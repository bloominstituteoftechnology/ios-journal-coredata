//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Bronson Mullens on 6/5/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    // MARK: - Properties
    var entry: Entry?
    var wasEdited: Bool = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var entryBody: UITextView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = entryTitle.text,
                !title.isEmpty,
                let entry = entry else { return }
            let bodyText = entryBody.text
            entry.title = title
            entry.bodyText = bodyText
            let moodIndex = moodControl.selectedSegmentIndex
            entry.mood = Mood.allCases[moodIndex].rawValue
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    // MARK: - Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        entryTitle.isUserInteractionEnabled = editing
        entryBody.isUserInteractionEnabled = editing
        moodControl.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    // MARK: - Private
    private func updateViews() {
        entryTitle.text = entry?.title
        entryBody.text = entry?.bodyText
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood) ?? Mood.neutral
        } else {
            mood = .neutral
        }
        moodControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodControl.isUserInteractionEnabled = isEditing
    }
    
}
