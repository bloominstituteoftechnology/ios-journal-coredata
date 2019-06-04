//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jeremy Taylor on 6/3/19.
//  Copyright © 2019 Bytes Random L.L.C. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let entryTitle = titleTextField.text,
            !entryTitle.isEmpty,
        let entryText = textView.text,
            !entryText.isEmpty else { return }
        
        if let entry = entry {
            entryController?.update(entry: entry, title: entryTitle, bodyText: entryText)
        } else {
            entryController?.createEntry(title: entryTitle, bodyText: entryText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        textView.text = entry?.bodyText
        
    }
}
