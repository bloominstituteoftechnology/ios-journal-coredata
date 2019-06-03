//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = bodyTextView.text
            else { return }

        guard let entry = entry else {
            entryController?.createEntry(title: title, bodyText: bodyText)
            navigationController?.popViewController(animated: true)
            return

        }
        entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
        navigationController?.popViewController(animated: true)

    }

    func updateViews() {
        guard isViewLoaded else {
            return
        }
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
    }

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
}
