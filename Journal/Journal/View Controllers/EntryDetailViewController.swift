//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
   
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
                   !name.isEmpty else { return }
               let description = descriptionTextView.text
        
        let moodIndex = segmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, newTitle: name, newDescription: description ?? "", newMood: mood.rawValue)
        } else {
            entryController?.create(title: name, time: Date(), description: description ?? "", mood: mood.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        self.title = entry?.title ?? "Create Entry"
        nameTextField.text = entry?.title
        descriptionTextView.text = entry?.bodyText
        let mood: Mood
        if let aMood = entry?.mood {
            mood = Mood(rawValue: aMood)!
        } else {
            mood = .normal
        }
        segmentedControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood)!
    }
}

