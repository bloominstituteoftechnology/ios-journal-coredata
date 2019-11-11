//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
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
    }
    // MARK: - Functions
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
    }
    
    // MARK: - IBActions
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let entryController = entryController,
            let title = titleTextField.text,
            !title.isEmpty else { return }
        let body = bodyTextView.text
        
        if let entry = entry {
            entryController.update(for: entry, title: title, bodyText: body)
        } else {
            entryController.create(title: title, timestamp: Date(), bodyText: body, identifier: nil)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
