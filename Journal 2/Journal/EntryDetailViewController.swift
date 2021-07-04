//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {

        guard let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = bodyTextView.text
            else { return }

        let entryIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = EntryMood.allMoods[entryIndex]

        if let entry = entry {
            // Editing existing task
            entry.title = title
            entry.mood = mood.rawValue
            entry.bodyText = bodyText
            entryController?.put(entry: entry)
        } else {
            let entry = Entry(title: title, bodyText: bodyText, mood: mood.rawValue)
            entryController?.put(entry:entry)
        }

        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }

        navigationController?.popViewController(animated: true)
    }

    func updateViews() {
        guard isViewLoaded else {
            return
        }
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText

        let mood: EntryMood
        if let entryMood = entry?.mood  {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .🍕
        }

        moodSegmentedControl.selectedSegmentIndex = EntryMood.allMoods.firstIndex(of: mood)!
    }

    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
}
