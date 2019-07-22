//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!

    
    var entry: Entry? {
        didSet {
            self.updateViews()
        }
    }
    var entryController: EntryController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty else { return }
        
        if let entry = entry {
            self.entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
        } else {
            self.entryController?.createEntry(title: title, bodyText: bodyText)
        }
        
        navigationController?.popViewController(animated: true)
    }

    
    
    func updateViews() {
        
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        
        
    }

}
