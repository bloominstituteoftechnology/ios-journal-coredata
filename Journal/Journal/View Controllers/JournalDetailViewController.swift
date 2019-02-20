//
//  JournalDetailViewController.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/18/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryController = entryController,
        let title = titleTextField.text,
        let body = detailsTextView.text else { return }
        
        let moods = Mood.allCases
        let moodIndex = segmentedControl.selectedSegmentIndex
        let mood = moods[moodIndex]
        
        if let entry = entry {
            entryController.update(name: title, body: body, mood: mood.rawValue, entry: entry)
        } else {
            entryController.create(name: title, body: body, mood: mood.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard let entry = entry else {
            navigationItem.title = "Create Entry"
            return
        }
        navigationItem.title = entry.name
        if let title = titleTextField {
            title.text = entry.name
        }
        
        if let details = detailsTextView {
            details.text = entry.bodyText
        }
        
        guard let moodString = entry.mood,
        let mood = Mood(rawValue: moodString),
        let index = Mood.allCases.firstIndex(of: mood) else { return }
        
        if let segmentedControl = segmentedControl {
            segmentedControl.selectedSegmentIndex = index
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
}
