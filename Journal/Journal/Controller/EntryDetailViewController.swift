//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/5/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
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
    
    //MARK: - Functions
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title
        textView.text = entry?.bodyText
        textView.layer.cornerRadius = 10
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryController = entryController else { return}
        guard let title = textField.text else { return }
        guard !title.isEmpty else { return }
        let body = textView.text
        
        if let entry = entry {
            entryController.update(for: entry, title: title, bodyText: body)
        } else {
            entryController.create(title: title, timestamp: Date(), bodyText: body, identifier: nil)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
