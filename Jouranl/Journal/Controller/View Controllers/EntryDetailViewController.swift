//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Joshua Rutkowski on 2/12/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Functions
    func updateViews() {
        guard isViewLoaded else { return }
        
        self.title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
    }
    
    
    // MARK: - IBActions
    
    @IBAction func saveButton(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        let bodyText = entryTextView.text
        
        if let entry = entry {
            entryController?.update(entry: entry, newTitle: title, newBodyText: description)
        } else {
            entryController?.create(title: title, timestamp: Date(), bodyText: bodyText, identifier: "")
        }
        navigationController?.popViewController(animated: true)
    }
    
}
