//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by scott harris on 2/24/20.
//  Copyright © 2020 scott harris. All rights reserved.
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
    
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let body = bodyTextView.text, !body.isEmpty else { return }
        if let entry = entry {
            if let entryController = entryController {
                entryController.update(entry: entry, title: title, body: body)
            }
        } else {
            if let entryController = entryController {
                entryController.createEntry(title: title, body: body)
            }
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func updateViews() {
        guard let _ = titleTextField else { return }
        if let entry = entry {
            title = entry.title
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
        } else {
            title = "Create Entry"
            titleTextField.text = ""
            bodyTextView.text = ""
        }
        
    }
}
