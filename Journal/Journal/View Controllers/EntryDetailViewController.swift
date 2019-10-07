//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    var entryController: EntryController?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodSegmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        
        let capitalizedTitle = entry?.title?.capitalizingFirstLetter()
        
        self.textField.text = capitalizedTitle
        self.textView.text = entry?.bodyText
        
        if entry == nil {
            self.navigationItem.title = "Create Entry"
            textField.placeholder = "Enter Title Here"
        } else {
            self.navigationItem.title = entry?.title
        }
        
        var selectedMood: EntryMood
        if let moodString = entry?.mood,
           let entryMood = EntryMood(rawValue: moodString) {
            selectedMood = entryMood
        } else {
            selectedMood = .neutral
            
        }
        
        if let index = EntryMood.allCases.firstIndex(of: selectedMood) {
            moodSegmentedController.selectedSegmentIndex = index
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let textField = self.textField.text, !textField.isEmpty else { return }
        
        let textView = self.textView.text
        let moodIndex = moodSegmentedController.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, mood: mood.rawValue, title: textField, bodyText: textView ?? "")
        } else {
            entryController?.create(mood: mood, title: textField, bodyText: textView)

        }
        navigationController?.popViewController(animated: true)
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
