//
//  EntryDetailViewController.swift
//  Journal.CoreData
//
//  Created by beth on 2/24/20.
//  Copyright © 2020 elizabeth wingate. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
     @IBOutlet weak var textViewField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    @IBAction func saveEntry(_ sender: Any ) {
      guard let entryController = entryController,
            let entryTitle = titleTextField.text,
            let bodyText = textViewField.text
        else { return }

            if let entry = entry {
            entryController.update(entry: entry, title: entryTitle, bodyText: bodyText)
        } else {
            entryController.create(title: entryTitle, timeStamp: Date(), bodyText: bodyText, identifier: "")
        }
            navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
      guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        textViewField.text = entry?.bodyText
    }
}
