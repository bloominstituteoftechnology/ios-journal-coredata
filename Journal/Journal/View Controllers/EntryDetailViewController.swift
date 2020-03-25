//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var timestamp = Date()
    var entryController: EntryController?

    // MARK: - View Lifecycle
    
    func updateViews() {
        if let entry = entry {
            title = entry.title
            entryTitleTextField.text = entry.title
            entryTextView.text = entry.bodyText
        } else {
            title = "Create Entry"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entryTitleTextField.becomeFirstResponder()
        
        updateViews()
    }
        
    // MARK: - Actions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text,
            !title.isEmpty, let bodyText = entryTextView.text else {
                return
        }
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, timestamp: timestamp, context: CoreDataStack.shared.mainContext)
        }
        navigationController?.popViewController(animated: true)
    }

}
