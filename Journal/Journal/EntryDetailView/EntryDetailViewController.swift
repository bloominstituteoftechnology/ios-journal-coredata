//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var entry: Entry? { didSet { updateViews() }}
    var entryController: EntryController?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSelector: UISegmentedControl!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.becomeFirstResponder()
        titleTextField.delegate = self
        setBorder(for: titleTextField, bodyTextView)
        updateViews()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let entryController = entryController,
            let title = titleTextField.text else { return }
        let body = bodyTextView.text
        let moodIndex = moodSelector.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        
        if let entry = entry {
            entryController.update(entry, title: title, bodyText: body, mood: mood)
        } else {
            entry = entryController.createEntry(title: title, bodyText: body, mood: mood)
        }
        
        entryController.sendEntryToServer(entry!)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Private
    
    private func setBorder(for views: UIView...) {
        views.forEach {
            $0.layer.borderColor = UIColor.systemGray3.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 6.0
        }
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        if let entry = entry {
            title = entry.title
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            
            let index = Mood.allCases.firstIndex(of: entry.mood)
            moodSelector.selectedSegmentIndex = index ?? 1
        } else {
            title = "Create Entry"
        }
    }
}


// MARK: - Text Field Delegate

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bodyTextView.becomeFirstResponder()
        return true
    }
}

