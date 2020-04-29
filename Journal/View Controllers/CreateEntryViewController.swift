//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Chad Parker on 4/22/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    let entryController = EntryController()

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard
            let title = titleTextField.text,
            !title.isEmpty,
            let body = bodyTextView.text else { return }
        
        let mood = Mood.allCases[moodSegmentControl.selectedSegmentIndex]
            
        let entry = Entry(title: title,
              mood: mood,
              bodyText: body,
              context: CoreDataStack.shared.mainContext)
        do {
            try CoreDataStack.shared.mainContext.save()
            entryController.sendEntryToServer(entry)
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
