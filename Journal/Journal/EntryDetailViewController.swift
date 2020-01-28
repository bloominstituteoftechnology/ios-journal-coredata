//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jorge Alvarez on 1/27/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        print("save tapped")
        guard let title = textField.text, let body = textView.text, !title.isEmpty, !body.isEmpty else {return}
        print("title and body text exist")
        
        let moodIndex = moodControl.selectedSegmentIndex
        let selectedMood = Mood.allMoods[moodIndex]
        
        if let entry = entry {
            entryController?.update(title: title, bodyText: body, mood: selectedMood, entry: entry)
        } else {
            entryController?.createEntry(title: title,
                                         bodyText: body,
                                         timestamp: Date(),
                                         identifier: "\(Int.random(in: 1...690))",
                                         mood: selectedMood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else {return}
        
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title ?? ""
        textView.text = entry?.bodyText ?? ""
        
        let selectedMood: Mood
        if let unwrappedMood = entry?.mood {
            selectedMood = Mood(rawValue: unwrappedMood)!
        } else {
            selectedMood = .neutral
        }
        moodControl.selectedSegmentIndex = Mood.allMoods.firstIndex(of: selectedMood) ?? 1
        
    }
}
