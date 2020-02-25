//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by Enrique Gongora on 2/24/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    //MARK: - IBAction
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let bodyText = bodyTextView.text, !bodyText.isEmpty else { return }
        if let entry = entry {
            if let entryController = entryController {
                entryController.updateEntry(entry: entry, title: title, bodyText: bodyText)
            }
        } else {
            if let entryController = entryController {
                entryController.createEntry(title: title, bodyText: bodyText)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - Function
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
