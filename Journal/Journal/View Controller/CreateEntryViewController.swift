//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Claudia Contreras on 4/22/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet var journalEntryTextField: UITextField!
    @IBOutlet var journalTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = journalEntryTextField.text, !title.isEmpty,
            let text = journalTextView.text, !text.isEmpty else { return }
        
        let currentDateTime = Date()
        
        Entry(identifier: "", title: title, bodyText: text, timestamp: currentDateTime, context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving manage object context: \(error)")
        }
    }
    

}

