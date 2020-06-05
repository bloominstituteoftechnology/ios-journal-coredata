//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = bodyTextView.text, !bodyText.isEmpty else { return }
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText)
        } else {
            entryController?.create(title: title, bodyText: bodyText)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        if isViewLoaded {
            guard let entry = entry else {
                title = "New Entry"
                titleTextField.becomeFirstResponder()
                return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let entryDate = dateFormatter.string(from: entry.timestamp!)
            
            title = entryDate
            
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
        }
    }
    
    // MARK: - Properties
    
    var entryController: EntryController?
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
}
