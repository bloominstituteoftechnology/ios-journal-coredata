//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Lambda_School_loaner_226 on 4/28/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import CoreData

class CreateEntryViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let entry = entryTextField.text, !entry.isEmpty,
            let notes = notesTextView.text, !notes.isEmpty else { return }
        
        Entry(title: entry,
              bodyText: notes,
              timeStamp: Date(),
              identifier: String(),
              context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving manage object context: \(error)")
        }
    }
    
    @IBAction func entryTextFieldEdited(_ sender: UITextField) {
        guard let entryText = entryTextField.text, !entryText.isEmpty else { return }
        
    }
    
    
    
    
}
