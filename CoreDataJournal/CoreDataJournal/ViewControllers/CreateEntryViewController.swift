//
//  CreateEntryViewController.swift
//  CoreDataJournal
//
//  Created by Marissa Gonzales on 5/18/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    @IBOutlet weak var entryDetailTextField: UITextView!
    @IBOutlet weak var entryTitleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        guard let entryTitle = entryTitleTextField.text,
            !entryTitle.isEmpty else { return }
        
        guard let entryDetail = entryDetailTextField.text,
            !entryDetail.isEmpty else { return }
        
        Entry(title: entryTitle, bodyText: entryDetail, context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

