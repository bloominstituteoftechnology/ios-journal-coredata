//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/1/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodytextTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    // MARK: Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodControl.layer.borderWidth = 2.0
        moodControl.layer.borderColor = UIColor.systemBlue.cgColor
        updateViews()
    }
    
    // MARK: Actions
    @IBAction func saveEntry(_ sender: Any) {
        guard let entryController = entryController,
            let entryTitle = titleTextField.text, !entryTitle.isEmpty,
            let bodyText = bodytextTextView.text else { return }
        
        guard let mood = moodControl.titleForSegment(at: moodControl.selectedSegmentIndex) else { return }
        
        if let entry = entry {
            entryController.update(title: entryTitle, bodyText: bodyText, entry: entry, mood: mood)
        } else {
            var identifier: String {
                let uuid = UUID()
                let identifier = uuid.uuidString
                return identifier
            }
            entryController.create(title: entryTitle,
                                   bodyText: bodyText,
                                   timeStamp: Date(),
                                   identifier: identifier,
                                   mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodytextTextView.text = entry?.bodyText
        
        var mood: Mood
        if let entryMoodString = entry?.mood, let entryMood = Mood(rawValue: entryMoodString) {
            mood = entryMood
        } else {
            mood = .interesting
        }
        if let index  = Mood.allCases.firstIndex(of: mood) {
            moodControl.selectedSegmentIndex = index
        }
    }
}
