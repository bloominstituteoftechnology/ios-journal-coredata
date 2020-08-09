//
//  CreateEntryViewController.swift
//  Journals
//
//  Created by Gladymir Philippe on 8/5/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var detailTextField: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let entryTitle = titleTextField.text, !entryTitle.isEmpty,
            let entryDetail = detailTextField.text, !entryDetail.isEmpty else { return }
        
        Entry(title: entryTitle, bodyText: entryDetail, context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    
}

