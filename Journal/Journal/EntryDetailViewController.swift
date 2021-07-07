//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    var entryController: EntryController?
    
    // MARK:  - Outlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - Action
    
    @IBAction func saveTapped(_ sender: Any) {
        
        var selectedMood: String = ""
        
        switch moodSegmentedControl.selectedSegmentIndex {
        case 0:
            selectedMood = MoodEmojis.angry.rawValue
        case 1:
            selectedMood = MoodEmojis.blah.rawValue
        case 2:
            selectedMood = MoodEmojis.happy.rawValue
        default:
            selectedMood = MoodEmojis.blah.rawValue
        }
        
        guard let entryController = entryController,
            let titleTextField = titleTextField.text,
            !titleTextField.isEmpty,
            let descriptionTextField = descriptionTextField.text,
            !descriptionTextField.isEmpty else { return }
        
        if let entry = entry {
            entryController.updateEntry(entry: entry,
                                        title: titleTextField,
                                        bodyText: descriptionTextField,
                                        mood: selectedMood)
        } else {
            entryController.createEntry(title: titleTextField,
                                        bodyText: descriptionTextField,
                                        mood: selectedMood)
        }
        navigationController?.popViewController(animated: true)
    }
    
//     MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateViews()
    }

    private func updateViews(){
        
        guard let entry = entry,
        isViewLoaded else {
            self.title = "Create Entry"
            return
        }
        self.title = entry.title
        titleTextField.text = entry.title
        descriptionTextField.text = entry.bodyText
        
        let mood: MoodEmojis
        if let selectedMood = entry.mood {
            mood = MoodEmojis(rawValue: selectedMood)!
        } else {
            mood = .blah
        }
        moodSegmentedControl.selectedSegmentIndex = MoodEmojis.allCases.firstIndex(of: mood) ?? 1
    }
    
    private func setupViews(){
        
        let segmentedFont = UIFont.systemFont(ofSize: 30)
        moodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: segmentedFont],
                                                    for: .normal)
        
        descriptionTextField.backgroundColor = UIColor.systemGray.withAlphaComponent(0.8)
        descriptionTextField.layer.cornerRadius = 20
      
        moodSegmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        moodSegmentedControl.selectedSegmentTintColor = UIColor.gray
     
        
        titleTextField.layer.cornerRadius = 15
        titleTextField.alpha = 0.8
        titleTextField.layer.borderColor = UIColor.black.withAlphaComponent(0.9).cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.clipsToBounds = true
        
        
    }
}
