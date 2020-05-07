//
//  ViewController.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var entryController: EntryController?
    var  entry: Entry? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else {return}
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        descriptionTextView.text = entry?.bodyText
    }

    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let body = descriptionTextView.text, !body.isEmpty else {return}
        if let entry = entry {
            entryController?.update(title: title, body: body, entry: entry)
        } else {
            entryController?.create(title: title, body: body)
        }
        navigationController?.popViewController(animated: true)
    }
    
}

