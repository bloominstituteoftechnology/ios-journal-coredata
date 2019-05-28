//
//  EnteryDetailViewController.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class EnteryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    var entryController: EntryController?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }

    func updateViews() {

        guard isViewLoaded else { return }

        title = entry?.title ?? "Create an Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
    }

    @IBAction func saveButtonTapped(_ sender: Any) {

        guard let title = titleTextField.text,
        let bodyText = bodyTextView.text,
        !title.isEmpty,
        !bodyText.isEmpty
        else {
            return
        }

        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText)
        }

        navigationController?.popToRootViewController(animated: true)
    }
}
