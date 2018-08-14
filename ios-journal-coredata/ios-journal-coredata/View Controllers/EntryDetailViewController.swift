//
//  EntryDetailViewController.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/13/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title
        textView.text = entry?.bodyText
    }

    @IBAction func save(_ sender: Any) {
        guard let textField = textField.text,
            let textView = textView.text else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: textField, bodyText: textView)
            entryController?.saveToPersistentStore()
        } else {
            entryController?.createEntry(title: textField, identifier: UUID().uuidString, bodyText: textView)
            entryController?.saveToPersistentStore()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
}
