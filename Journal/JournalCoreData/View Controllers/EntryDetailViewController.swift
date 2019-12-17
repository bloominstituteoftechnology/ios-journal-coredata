//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by Spencer Curtis on 8/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var moodControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
//    moodControl.
    
    @IBAction func saveEntry(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else { return }
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = Mood.allMoods[moodIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
        } else {
            entryController?.createEntry(with: title, bodyText: bodyText, mood: mood.rawValue)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard let entry = entry,
            isViewLoaded else {
                title = "Create Entry"
                return
        }
        
        title = entry.title
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
        let mood: Mood
        if let entryMood = entry.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .👍
        }
        moodControl.selectedSegmentIndex = Mood.allMoods.firstIndex(of: mood) ?? 1
    }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!

}
