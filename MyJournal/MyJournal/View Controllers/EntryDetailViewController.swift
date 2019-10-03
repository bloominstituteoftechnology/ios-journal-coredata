//
//  EntryDetailViewController.swift
//  MyJournal
//
//  Created by Eoin Lavery on 02/10/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    //MARK: - IBOUTLETS
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: - PROPERTIES
    var entriesController: EntriesController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    //MARK: - PRIVATE FUNCTIONS
    private func updateViews() {
        guard isViewLoaded else { return }
        
        guard let entry = entry else {
            title = "New Entry"
            saveButton.isEnabled = false
            return
        }
        
        title = entry.name
        titleTextField.text = entry.name
        notesTextView.text = entry.bodyText
    }
    
    @IBAction func textEditingDidChange(_ sender: Any) {
        if let name = titleTextField.text, !name.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    //MARK: - IBACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = titleTextField.text,
            let bodyText = notesTextView.text,
            !name.isEmpty else { return }
        
        if let entry = entry {
            entriesController?.updateEntry(name: name, bodyText: bodyText, entry: entry)
        } else {
            entriesController?.createEntry(name: name, bodyText: bodyText)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
