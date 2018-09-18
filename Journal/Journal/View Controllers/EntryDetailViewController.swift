//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Daniela Parra on 9/17/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - 
    
    private func updateViews() {
        if isViewLoaded {
            //Set title for the case where we create a new entry.
            guard let entry = entry else {
                title = "Create Entry"
                return
            }
            
            //Set title and text to values from an existing entry.
            title = entry.title
            nameTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            
            //Check and unwrap mood from existing entry.
            let mood: Mood
            if let entryMood = entry.mood {
                mood = Mood(rawValue: entryMood) ?? .good
            } else {
                mood = .good
            }
            //Set mood segmented control's index to match mood from entry.
            guard let index = Mood.allMoods.index(of: mood) else { return }
            moodSegmentedControl.selectedSegmentIndex = index
        }
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = nameTextField.text,
            let bodyText = bodyTextView.text else { return }
        
        let index = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allMoods[index]
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood)
        } else {
            entryController?.createEntry(with: title, bodyText: bodyText, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Properties
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
}
