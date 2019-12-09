//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/5/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import UIKit

enum Mood: String, CaseIterable {
    case happy = "😭"
    case neutral = "😑"
    case sad = "🥰"
}

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
    
    //MARK: - Functions
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title
        
        let mood: Mood
        if let entryMood = entry?.mood,
            let _mood = Mood(rawValue: entryMood) {
            mood = _mood
        } else {
            mood = .neutral
        }
        
        let moodIndex = Mood.allCases.firstIndex(of: mood)!
        segmentedControl.selectedSegmentIndex = moodIndex
        
        textView.text = entry?.bodyText
        textView.layer.cornerRadius = 10
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryController = entryController,
            let title = textField.text,
            !title.isEmpty else { return }
        let body = textView.text
        let moodIndex = segmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        if let entry = entry {
            entryController.update(for: entry, title: title, bodyText: body, mood: mood.rawValue)
        } else {
            entryController.create(mood: mood.rawValue, title: title, timestamp: Date(), bodyText: body, identifier: nil)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
