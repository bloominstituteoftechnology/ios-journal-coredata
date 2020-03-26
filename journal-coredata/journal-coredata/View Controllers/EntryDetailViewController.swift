//
//  EntryDetailViewController.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    // MARK: -  Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodPicker: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViews()
    }

    
    // MARK: - Button Action
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        // Check that there's a title and unwrap the body text.
        guard let title = titleField.text,
            !title.isEmpty,
            let bodyText = textView.text else { return }
        
        // Get segment index and convert it to mood
        let mood = Mood.allCases[moodPicker.selectedSegmentIndex]
        
        // Check if an entry was passed in when entering this view
        guard let entry = entry else {
            // No entry = create new entry
            entryController?.create(title: title, bodyText: bodyText, mood: mood)
            navigationController?.popViewController(animated: true)
            return
        }
        
        // Find an entry = we're making changes.
        entryController?.update(for: entry, title: title, bodyText: bodyText, mood: mood)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Method
    
    private func updateViews() {
        if isViewLoaded, let entry = entry {
            title = entry.title
            titleField.text = entry.title
            textView.text = entry.bodyText
            guard let moodIndex = Mood.allCases.firstIndex(where: {$0.rawValue == entry.mood }) else { return }
            moodPicker.selectedSegmentIndex = moodIndex
            print("moodIndex: \(moodIndex) and mood: \(entry.mood)")
        } else {
            title = "Create Entry"
        }
        
        
        
    }

}

