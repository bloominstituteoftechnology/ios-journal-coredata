//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Cameron Collins on 4/20/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        Entry(title: titleTextField.text!, bodyText: bodyTextView.text)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

