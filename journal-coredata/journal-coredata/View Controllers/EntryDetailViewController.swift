//
//  EntryDetailViewController.swift
//  journal-coredata
//
//  Created by Alex Shillingford on 8/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
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
        
        self.title = entry?.title
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryController = entryController else { return }
        if let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty, !bodyText.isEmpty {
            if let entry = entry {
                entryController.updateEntry(entry: entry, title: title, bodyText: bodyText, timestamp: Date())
            } else {
                entryController.createEntry(title: title, bodyText: bodyText)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
