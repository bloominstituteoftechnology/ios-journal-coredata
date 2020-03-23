//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - Properties
    
    var date = Date()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entryTitleTextField.becomeFirstResponder()
    }
        
    // MARK: - Actions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text,
            !title.isEmpty else {
                return
        }
        
        let entryText = entryTextView.text
        Journal(title: title, entry: entryText, date: date, context: CoreDataStack.shared.mainContext)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }

}
