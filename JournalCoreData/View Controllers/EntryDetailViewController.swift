//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by Gi Pyo Kim on 10/14/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
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

    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty, let body = bodyTextView.text, !body.isEmpty else { return }
        
        let mood = JournalMood.allCases[moodSegmentedControl.selectedSegmentIndex]
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, mood: mood, bodyText: body, context: CoreDataStack.shared.mainContext)
        } else {
            entryController?.createEntry(title: title, mood: mood, bodyText: body, context: CoreDataStack.shared.mainContext)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        
        if let mood = JournalMood(rawValue: entry?.mood ?? JournalMood.normal.rawValue), let moodIndex = JournalMood.allCases.firstIndex(of: mood) {
            moodSegmentedControl.selectedSegmentIndex = moodIndex
        }
    }
}
