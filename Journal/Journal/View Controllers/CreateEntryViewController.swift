//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Eoin Lavery on 06/08/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    //MARK: - IBOUTLETS
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Entry"
    }
    
    //MARK: - IBACTIONS
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            let description = descriptionTextView.text,
            !title.isEmpty, !description.isEmpty else {
                print("Error with entered data, make sure all data is entered correctly.")
                return
        }
        
        let _ = Entry(title: title, bodyText: description)
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            print("Error saving Journal Entry to ManagedObjectContext: \(error)")
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

