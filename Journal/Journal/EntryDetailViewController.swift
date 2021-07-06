//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Kobe McKee on 6/3/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
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
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    func updateViews() {
        guard isViewLoaded else { return }
        if entry != nil {
            title = entry?.title
            titleTextField.text = entry?.title
            bodyTextView.text = entry?.bodyText
        } else {
            title = "Create New Entry"
        }
    }
    
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text,
            !title.isEmpty,
            let body = bodyTextView.text,
            !body.isEmpty else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: body)
        } else {
            entryController?.createEntry(title: title, bodyText: body)
        }
        
        navigationController?.popViewController(animated: true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }


}
