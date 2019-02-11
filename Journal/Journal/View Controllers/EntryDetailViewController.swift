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
        
        _ = Entry(title: title, bodyText: bodyText)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard let entry = entry else {
            title = "New Entry"
            titleTextField.becomeFirstResponder()
            return }
        
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
    }
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
}
