//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Isaac Lyons on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
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
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        descriptionTextView.text = entry?.bodyText
        
        if let mood = EntryMood(rawValue: entry?.mood ?? EntryMood.happy.rawValue),
            let moodIndex = EntryMood.allCases.firstIndex(of: mood) {
            moodSegmentedControl.selectedSegmentIndex = moodIndex
        }
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let description = descriptionTextView.text,
            let moodText = moodSegmentedControl.titleForSegment(at: moodSegmentedControl.selectedSegmentIndex),
            let mood = EntryMood(rawValue: moodText),
            !title.isEmpty,
            !description.isEmpty else { return }
        
        
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: description, mood: mood)
        } else {
            entryController?.createEntry(title: title, bodyText: description, mood: mood, context: CoreDataStack.shared.mainContext)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
