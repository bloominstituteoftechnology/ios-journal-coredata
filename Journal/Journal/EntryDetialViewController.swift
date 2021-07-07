//
//  EntryDetialViewController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/16/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit

class EntryDetialViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews(){
        title = entry?.title ?? "Create Entry"
        guard let entry = entry, self.isViewLoaded else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodytext
        let mood: EntryMood
        if let entryMood = entry.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .happy
        }
        moodSegmentedControl.selectedSegmentIndex = EntryMood.allMoods.firstIndex(of: mood) ?? 0
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let bodyText = bodyTextView.text else { return }
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = EntryMood.allMoods[moodIndex]
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
            navigationController?.popViewController(animated: true)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood.rawValue)
            navigationController?.popViewController(animated: true)
        }
    }
    
}

