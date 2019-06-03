//
//  EntryDetailViewController.swift
//  Journal - Day One
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Prepare to create or update a new journal entry
        updateViews()
    }
    
    // MARK: - Private Functions
    private func updateViews() {
        if isViewLoaded {
            guard let entry = entry else {
                title  = "New Entry"
                titleTextField.becomeFirstResponder()
                return
            }
            title = entry.title
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
        }
    }
    
    // MARK: - Save Button
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Update a sent entry
        
        // Save a new entry
    }
    
    // MARK: - Properties
    var entryController: EntryController?
    var entry: Entry? { didSet {updateViews()} }
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
}
