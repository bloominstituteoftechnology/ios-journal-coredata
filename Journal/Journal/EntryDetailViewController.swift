//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Mitchell Budge on 6/3/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let entry = entry {
            titleTextField.text = entry.title
            textView.text = entry.bodyText
            title = entry.title
        } else {
            title = "Create Entry"
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
        let bodyText = textView.text, !bodyText.isEmpty else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID().uuidString)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Properties
   
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
   
    var entryController: EntryController?
}
