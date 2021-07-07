//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = bodyTextView.text, !bodyText.isEmpty else { return }
        
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = EntryMood.allMoods[moodIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
        } else {
            entryController?.create(title: title, bodyText: bodyText, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        if isViewLoaded {
            guard let entry = entry else {
                title = "New Entry"
                moodSegmentedControl.selectedSegmentIndex = 1
                titleTextField.becomeFirstResponder()
                return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let entryDate = dateFormatter.string(from: entry.timestamp!)
            
            title = entryDate
            
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            
            var index: Int = 1
            
            switch entry.mood {
            case EntryMood.sad.rawValue:
                index = 0
            case EntryMood.neutral.rawValue:
                index = 1
            case EntryMood.happy.rawValue:
                index = 2
            default:
                index = 1
            }
            
            moodSegmentedControl.selectedSegmentIndex = index
        }
    }
    
    // MARK: - Properties
    
    var entryController: EntryController?
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
}
