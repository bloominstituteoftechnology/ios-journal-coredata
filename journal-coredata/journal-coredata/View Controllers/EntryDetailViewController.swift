//
//  EntryDetailViewController.swift
//  journal-coredata
//
//  Created by Alex Shillingford on 8/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
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
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        self.title = entry?.title
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        if let moodString = entry?.mood,
            let mood = Moods(rawValue: moodString) {
            let moodIndex = Moods.allCases.firstIndex(of: mood) ?? 1
            
            moodSegmentedControl.selectedSegmentIndex = moodIndex
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryController = entryController else { return }
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Moods.allCases[moodIndex]
        if let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty, !bodyText.isEmpty {
            if let entry = entry {
                entryController.updateEntry(entry: entry, title: title, bodyText: bodyText, timestamp: Date(), mood: mood)
            } else {
                entryController.createEntry(title: title, bodyText: bodyText, mood: mood)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
