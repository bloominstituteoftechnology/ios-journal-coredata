//
//  ViewController.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: Properties
    var journalEntry: Entry?
    var entryController: EntryController?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        if journalEntry == nil {
            //save Button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntry))
            //cancel Button
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updateEntry))
        }
        bodyTextView.backgroundColor = .systemBackground
        title = journalEntry?.title ?? "New Entry"
        titleTextField.text = journalEntry?.title ?? ""
        bodyTextView.text = journalEntry?.bodyText ?? ""
        guard let moodIndex = MoodType.allMoods.firstIndex(of: MoodType(rawValue: journalEntry?.mood ?? "😑") ?? .neutral) else {return}
        segmentedControl.selectedSegmentIndex = moodIndex
       
    }
    
    @objc func dismissView() {
        if journalEntry == nil {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: Create/Save
    @objc func saveEntry() {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = bodyTextView.text,
            !bodyText.isEmpty
        else {return}
        let moodType = MoodType.allMoods[segmentedControl.selectedSegmentIndex]
        entryController?.createEntry(title: title, bodyText: bodyText, mood: moodType)
        dismissView()
    }
    
    @objc func updateEntry() {
        guard let entry = journalEntry,
            let newTitle = titleTextField.text,
            !newTitle.isEmpty,
            let newBodyText = bodyTextView.text,
            !newBodyText.isEmpty,
            let id = entry.identifier,
            let mood = entry.mood
        else {return}
        let rep = EntryRepresentation(bodyText: newTitle, identifier: id.uuidString, mood: mood, timestamp: Date(), title: newTitle)
        entryController?.updateEntry(entry: entry, entryRep: rep)
        dismissView()
    }
    
}

