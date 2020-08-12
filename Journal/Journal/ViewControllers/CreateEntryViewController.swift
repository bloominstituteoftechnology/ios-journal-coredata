//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Cora Jacobson on 8/3/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import UIKit
import CoreData

class CreateEntryViewController: UIViewController {
    
    var entryController: EntryController?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = bodyTextView.text,
            !bodyText.isEmpty else { return }
        let mood = Mood.allCases[moodSegmentedControl.selectedSegmentIndex]
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        entryController?.sendEntryToServer(entry: entry)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}

