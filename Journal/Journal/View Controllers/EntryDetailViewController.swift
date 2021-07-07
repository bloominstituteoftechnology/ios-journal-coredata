//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Scott Bennett on 9/24/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodButton: UISegmentedControl!
    
    // MARK: Properties
        
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            guard let entry = entry else {
                title = "Create Entry"
                return
            }
        
            title = entry.title
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            
            let mood: EntryMood
            if let entryMood = entry.mood {
                mood = EntryMood(rawValue: entryMood) ?? .neutral
            } else {
                mood = .neutral
            }
            
            guard let entryMood = EntryMood.allMoods.index(of: mood) else { return }
            moodButton.selectedSegmentIndex = entryMood
        }
    }

    
    @IBAction func saveButton(_ sender: Any) {

        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else { return }
        
        let moodIndex = moodButton.selectedSegmentIndex
        let mood = EntryMood.allMoods[moodIndex]
        
        guard let entry = entry else {
            entryController?.create(title: title, bodyText: bodyText, mood: mood)
            navigationController?.popViewController(animated: true)
        return
        }
        
        entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood)
        self.navigationController?.popViewController(animated: true)
    }

}


