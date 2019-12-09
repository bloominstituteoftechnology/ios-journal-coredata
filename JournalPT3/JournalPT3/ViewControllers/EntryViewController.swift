//
//  EntryViewController.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodytextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
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
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let entryController = entryController,
            let entryTitle = titleTextField.text, !entryTitle.isEmpty,
            let bodyText = bodytextView.text else { return }
        
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = EntryMood.allMoods[moodIndex]
        
        if let entry = entry {
            entryController.updateEntry(title: entryTitle, mood: mood, bodyText: bodyText, entry: entry)
        } else {
            entryController.createEntry(title: entryTitle, mood: mood, bodyText: bodyText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodytextView.text = entry?.bodyText
    }
}
