//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by scott harris on 2/24/20.
//  Copyright © 2020 scott harris. All rights reserved.
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
    
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let body = bodyTextView.text, !body.isEmpty else { return }
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        if let entry = entry {
            if let entryController = entryController {
                entryController.update(entry: entry, title: title, body: body, mood: mood.rawValue)
            }
        } else {
            if let entryController = entryController {
                entryController.createEntry(title: title, body: body, mood: mood.rawValue)
            }
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func updateViews() {
        guard let _ = titleTextField else { return }
        if let entry = entry {
            title = entry.title
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            let mood = Mood(rawValue: entry.mood!)
            if let moodIndex = Mood.allCases.firstIndex(of: mood!) {
               moodSegmentedControl.selectedSegmentIndex = moodIndex
            }
            
        } else {
            title = "Create Entry"
            titleTextField.text = ""
            bodyTextView.text = ""
            moodSegmentedControl.selectedSegmentIndex = 1
        }
        
    }
}
