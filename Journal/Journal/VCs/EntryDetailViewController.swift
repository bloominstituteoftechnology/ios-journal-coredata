//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Samantha Gatt on 8/13/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    
    // MARK: - Functions
    
    func updateViews() {
        guard isViewLoaded else { return }
        navigationController?.title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title ?? ""
        bodyTextView.text = entry?.body ?? ""
        
        guard let entryMoodRawValue = EntryMood(rawValue: entry?.mood ?? "😐"),
            let entryMoodIndex = EntryMood.moods.index(of: entryMoodRawValue) else { return }
        moodSegmentedControl.selectedSegmentIndex = entryMoodIndex
    }
    
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let body = bodyTextView.text
        let mood = EntryMood.moods[moodSegmentedControl.selectedSegmentIndex]
        
        if let thisEntry = entry {
            entryController?.update(entry: thisEntry, title: title, body: body, mood: mood)
        } else {
            entryController?.create(title: title, body: body, mood: mood)
        }
        
        entryController?.saveToPersistentStore()
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
}
