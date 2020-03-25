//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var timestamp = Date()
    var entryController: EntryController?

    // MARK: - View Lifecycle
    
    func updateViews() {
        guard isViewLoaded else { return }
        if let entry = entry,
            let title = entry.title,
            let bodyText = entry.bodyText,
            let mood = entry.mood {
            
            entryTitleTextField.text = title
            entryTextView.text = bodyText
            
            let moodIndex: Int
            if mood == Mood.happy.rawValue {
                moodIndex = 0
            } else if mood == Mood.neutral.rawValue {
                moodIndex = 1
            } else {
                moodIndex = 2
            }
            moodSegmentedControl.selectedSegmentIndex = moodIndex
        } else {
            title = "Create Entry"
            moodSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entryTitleTextField.becomeFirstResponder()
        
        updateViews()
    }
        
    // MARK: - Actions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text,
            !title.isEmpty, let bodyText = entryTextView.text else {
                return
        }
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex].rawValue
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, mood: mood)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, context: CoreDataStack.shared.mainContext)
        }
        navigationController?.popViewController(animated: true)
    }

}
