//
//  ViewController.swift
//  Journal
//
//  Created by Harmony Radley on 4/20/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField! // title
    @IBOutlet weak var bodyTextView: UITextView! // bodyText
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
    }

    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty else  { return }
        
        guard let bodyText = bodyTextView.text,
            !bodyText.isEmpty else { return }
        
        let timestamp = Date()
        
        Entry(title: title, bodyText: bodyText, timestamp: timestamp)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

