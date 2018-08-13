//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    
    @IBAction func save(_ sender: Any) {
        guard let title = textField.text, let bodyText = textView.text else { return }
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText)
            navigationController?.popViewController(animated: true)
        } else {
            entryController?.create(title: title, bodyText: bodyText)
            navigationController?.popViewController(animated: true)
        }
        
        entryController?.saveToPersistentStore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        navigationItem.title = entry?.title ?? "Create Entry"
        textField?.text = entry?.title
        textView?.text = entry?.bodyText
    }

    
}
