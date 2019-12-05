//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Craig Swanson on 12/3/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodytextTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }

    @IBAction func saveJournalEntry(_ sender: UIBarButtonItem) {
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodytextTextField.text = entry?.bodyText
    }
    
}
