//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Thomas Cacciatore on 6/10/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
            title = entry?.title ?? "Create Entry"
            titleTextField.text = entry?.title
            bodyTextView.text = entry?.bodyText
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        guard let body = bodyTextView.text, !body.isEmpty else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: body)
        } else {
            entryController?.createEntry(title: title, bodyText: body)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
   
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
}
