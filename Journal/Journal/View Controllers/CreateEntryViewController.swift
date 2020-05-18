//
//  ViewController.swift
//  Journal
//
//  Created by Kelson Hartle on 5/17/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    var complete = false
    
    @IBOutlet weak var journalTitleTextField: UITextField!
    @IBOutlet weak var journalTextEntryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        journalTitleTextField.becomeFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let title = journalTitleTextField.text,
            !title.isEmpty else { return }
        
        guard let textEntry = journalTextEntryTextView.text,
            !textEntry.isEmpty else { return }
        
        
        Entry(bodyText: textEntry, title: title, complete: complete)
    
        do {
            try CoreDataStack.shared.mainContext.save()
            
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    


}

