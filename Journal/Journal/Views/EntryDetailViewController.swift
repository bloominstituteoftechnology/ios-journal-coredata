//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Bobby Keffury on 10/2/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let title = titleTextField.text, !title.isEmpty, let bodyText = entryTextView.text, !bodyText.isEmpty else { return }
        
        if let entry = entry {
            entryController?.Update(title: title, bodyText: bodyText, entry: entry)
        } else {
            entryController?.Create(title: title, bodyText: bodyText)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
