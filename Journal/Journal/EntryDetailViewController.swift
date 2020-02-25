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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    // MARK: - Properties
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let entryController = entryController,
        let titleTextField = titleTextField.text,
        !titleTextField.isEmpty,
        let descriptionTextField = descriptionTextField.text,
        !descriptionTextField.isEmpty else { return }

        if let entry = entry {
            
            entryController.updateEntry(entry: entry,
                                        title: titleTextField,
                                        bodyText: descriptionTextField)
        } else {
            entryController.createEntry(title: titleTextField,
                                        bodyText: descriptionTextField)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews(){
        if let entry = entry {
            self.title = entry.title
            titleTextField.text = entry.title
            descriptionTextField.text = entry.bodyText
        } else {
            self.title = "Create Entry"
        }
    }
    
}
