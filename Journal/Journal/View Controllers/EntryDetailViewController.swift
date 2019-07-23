//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Sean Acres on 7/22/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
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
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        
        let mood: Mood
        
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .neutral
        }
        
        moodControl.selectedSegmentIndex = Mood.allMoods.firstIndex(of: mood)!
    }

    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty,
            !bodyText.isEmpty else { return }
        
        let mood = Mood.allMoods[moodControl.selectedSegmentIndex].rawValue
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, mood: mood)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }

}
