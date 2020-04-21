//
//  ViewController.swift
//  Journal
//
//  Created by Dahna on 4/20/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let titleText = titleTextField.text,
            !titleText.isEmpty else { return }
        guard let entryText = entryTextView.text,
            !entryText.isEmpty else { return }
        
        Entry(title: titleText, bodyText: entryText, timestamp: Date())
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object: \(error)")
            return
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

