//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Kenneth Jones on 6/3/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryBody: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryTitle.becomeFirstResponder()
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = entryTitle.text,
            !title.isEmpty else { return }
        
        let body = entryBody.text
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        let entry = Entry(title: title, bodyText: body, mood: mood)
        entryController?.sendEntryToServer(entry: entry)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

