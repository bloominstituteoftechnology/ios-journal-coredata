//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Tobi Kuyoro on 27/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var entryTextField: UITextField!
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
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = entryTextField.text,
            let bodyText = entryTextView.text else { return }
            
        if let entry = entry {
            entryController?.update(entry: entry, called: title, bodyText: bodyText, timeStamp: entry.timeStamp ?? Date(), identifier: entry.identifier ?? "" )
        } else {
            entryController?.createEntry(called: title, bodyText: bodyText, timeStamp: Date(), identifier: "")
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        entryTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
    }
}
