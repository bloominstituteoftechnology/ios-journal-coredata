//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    
    var entry: Entry?
    var entryController: EntryController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        save()
    }
    
    // MARK: - Methods
    
    private func save() {
        guard let title = titleField.text, !title.isEmpty,
            let body = bodyView.text, !body.isEmpty
            else {
                print("Attempting to save with empty title and/or body.")
                return
        }
        if let entry = entry {
            entryController?.update(entry: entry, withNewTitle: title, body: body)
        } else {
            entryController?.create(entryWithTitle: title, body: body)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else {
            print("Attempted to update views when view was not loaded.")
            return
        }
        
        title = entry?.title ?? "Create Entry"
        titleField.text = entry?.title ?? ""
        bodyView.text = entry?.bodyText ?? ""
    }
}
