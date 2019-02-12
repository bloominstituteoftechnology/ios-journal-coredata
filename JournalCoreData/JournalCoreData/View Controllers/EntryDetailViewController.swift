//
//  ViewController.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    
    var entryController: EntryController?
    var  entry: Entry? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else {return}
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        descriptionTextView.text = entry?.bodyText
        
        if let entry = entry {
            guard let moodString = entry.mood,
                let mood = Mood(rawValue: moodString),
                let moodIndex = Mood.allCases.index(of: mood) else {return}
            
            moodSegmentedControl.selectedSegmentIndex = moodIndex
        } else {
            moodSegmentedControl.selectedSegmentIndex = 1
        }
    
        
    }

    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let body = descriptionTextView.text, !body.isEmpty else {return}
        let selectedIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[selectedIndex]
        if let entry = entry {
            entryController?.update(title: title, body: body, entry: entry, mood: mood.rawValue)
        } else {
            entryController?.create(title: title, body: body, mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
}

