//
//  ViewController.swift
//  Journal
//
//  Created by Bradley Yin on 8/19/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
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
    
    var entryController: EntryController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let entry = entry, isViewLoaded else { return }
        title = entry.title
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, let bodyText = bodyTextView.text, !title.isEmpty, !bodyText.isEmpty else { return }
        
        if let entry = entry {
            entryController.updateEntry(entry: entry, with: title, bodyText: bodyText)
        } else {
            entryController.createEntry(with: title, timeStamp: Date(), bodyText: bodyText, identifier: "placeHolder")
        }
        navigationController?.popViewController(animated: true)
    }
}

