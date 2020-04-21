//
//  ViewController.swift
//  JournalCoreData
//
//  Created by Bhawnish Kumar on 4/20/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = entryTextField.text,
            !title.isEmpty,
            let bodyText = descriptionTextView.text, !bodyText.isEmpty else {
                return
        }
        
        Entry(title: title, bodyText: bodyText, timeStamp: Date(), context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
}

