//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    
    var entry: Entry?
    var entryController: EntryController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyView: UITextView!
    @IBOutlet weak var moodSelector: UISegmentedControl!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMoodControlFromModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        save()
    }
    
    // MARK: - Methods
    
    private func save() {
        guard let title = titleField.text, !title.isEmpty,
            let body = bodyView.text, !body.isEmpty
            else {
                print("Attempting to save with empty title and/or body.")
                return
        }
        let moodIndex = moodSelector.selectedSegmentIndex
        let mood = Entry.Mood.allCases[moodIndex]
        if let entry = entry {
            entryController?.update(entry: entry,
                                    withNewTitle: title,
                                    body: body,
                                    mood: mood)
        } else {
            entryController?.create(entryWithTitle: title,
                                    body: body,
                                    mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else {
            print("Attempted to update views when view was not loaded.")
            return
        }
        title = entry?.title ?? "Create Entry"
        titleField.text = entry?.title ?? ""
        bodyView.text = entry?.bodyText ?? ""
        if let entryMoodEmoji = entry?.mood {
            let mood = Entry.Mood(rawValue: entryMoodEmoji) ?? .neutral
            let moodIndex = Entry.Mood.allCases.firstIndex(of: mood)!
            moodSelector.selectedSegmentIndex = moodIndex
        }
    }
    
    // TODO: ensure that moodControl options match model
    private func updateMoodControlFromModel() {
//        let moodCount = Entry.Mood.allCases.count
//        if moodCount != moodControl.numberOfSegments {
//            moodControl.removeAllSegments()
//            for i in 0..<Entry.Mood.allCases.count {
//                let mood = Entry.Mood.allCases[i]
//                moodControl.insertSegment(withTitle: mood.rawValue, at: i, animated: false)
//            }
//        }
    }
}
