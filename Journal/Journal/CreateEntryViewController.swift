//
//  ViewController.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelCreate(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func saveJournal(_ sender: Any) {
        guard let title = titleTextField.text,
            let entry = entryTextView.text,
            !title.isEmpty,
            !entry.isEmpty else { return }
        
        Entry(title: title, bodyText: entry, timestamp: Date(), context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
}

