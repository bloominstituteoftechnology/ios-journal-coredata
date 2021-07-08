//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum Mood: String, CaseIterable {
    case happy = "🙂"
    case neutral = "😐"
    case sad = "☹️"
}

class EntryDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    
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
    // MARK: - Functions
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        
        let mood: Mood
        if let entryMood = entry?.mood,
            let _mood = Mood(rawValue: entryMood) {
            mood = _mood
        } else {
            mood = .neutral
        }
        
        let moodIndex = Mood.allCases.firstIndex(of: mood)!
        moodSegmentedControl.selectedSegmentIndex = moodIndex
        
        bodyTextView.text = entry?.bodyText
        bodyTextView.layer.cornerRadius = 10
    }
    
    // MARK: - IBActions
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let entryController = entryController,
            let title = titleTextField.text,
            !title.isEmpty else { return }
        let body = bodyTextView.text
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        if let entry = entry {
            entryController.update(for: entry, title: title, bodyText: body, mood: mood.rawValue)
        } else {
            entryController.create(title: title, timestamp: Date(), mood: mood.rawValue, bodyText: body)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
