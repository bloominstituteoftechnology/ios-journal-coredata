//
//  ViewController.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/22/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    //MARK: - Properties and IBOutlets -
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    
    //MARK: - Methods and IBOutlets -
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text,
              let body = bodyTextView.text,
              !title.isEmpty,
              !body.isEmpty else { return }
        
        Entry(title: title, bodyText: body, timestamp: Date(), context: CoreDataStack.shared.mainContext)
        
        do {
        try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Could not save new user entry: \(error)")
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
} //End of class

