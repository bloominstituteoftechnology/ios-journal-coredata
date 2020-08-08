//
//  CreateEntryViewController.swift
//  Journal (Core Data)
//
//  Created by Sammy Alvarado on 8/5/20.
//  Copyright © 2020 Sammy Alvarado. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var entryTitleLabel: UITextField!
    @IBOutlet weak var entryTextField: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        entryTextField.becomeFirstResponder()
    }

    // MARK: - IBAaction
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let title = entryTitleLabel.text,
            !title.isEmpty else { return }

        let entry = entryTextField.text!
        let timestamp = Date()
        Entry(bodyText: entry, title: title, timestamp: timestamp)

        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context \(error)")
        }

    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}

