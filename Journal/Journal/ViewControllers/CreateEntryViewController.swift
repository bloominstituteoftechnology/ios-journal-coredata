//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Stephanie Ballard on 5/18/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTitleTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryTitle = entryTitleTextField.text,
            let entryBody = entryBodyTextView.text,
            !entryTitle.isEmpty else { return }
        
        Entry(title: entryTitle, bodyText: entryBody)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

