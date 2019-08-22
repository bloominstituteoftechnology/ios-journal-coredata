//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - IBActions & Methods
    
    private func updateViews() {
        if let entry = entry,
            isViewLoaded {
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            title = entry.title
            
            if let moodString = entry.mood,
                let mood = Mood(rawValue: moodString) {
                let moodIndex = Mood.allCases.firstIndex(of: mood) ?? 1
                moodSegmentedControl.selectedSegmentIndex = moodIndex
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryTitle = titleTextField.text,
            let bodyText     = bodyTextView.text else { return }
        
        let timeInterval = TimeInterval(NSDate().timeIntervalSince1970)
        let timeStamp    = Date(timeIntervalSince1970: timeInterval)
        let moodIndex    = moodSegmentedControl.selectedSegmentIndex
        var mood: Mood
        
        switch moodIndex {
        case 0:
            mood = Mood.happy
        case 1:
            mood = Mood.neutral
        case 2:
            mood = Mood.sad
        default:
            mood = Mood.happy
        }
        
        if let entry = entry,
           let entryController = entryController {
            entryController.updateEntry(entry: entry, with: entryTitle, bodyText: bodyText, timeStamp: timeStamp, mood: mood)
            title = entryTitle
        } else {
            guard let entryController = entryController else { return }
            entryController.createEntry(with: entryTitle, bodyText: bodyText, timeStamp: timeStamp, mood: mood)
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
