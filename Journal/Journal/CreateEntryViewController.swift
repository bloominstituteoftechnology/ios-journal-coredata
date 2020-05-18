//
//  ViewController.swift
//  Journal
//
//  Created by ronald huston jr on 5/18/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.becomeFirstResponder()
    }

    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
        let entry = Entry(title: title, bodyText: entryTextView.text, timestamp: Date(), identifier: "17")
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("error saving managed object context: \(error)")
        }
    }
    
}

