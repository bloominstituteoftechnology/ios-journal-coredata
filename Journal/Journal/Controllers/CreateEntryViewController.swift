//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Brian Rouse on 5/18/20.
//  Copyright © 2020 Brian Rouse. All rights reserved.
//

import UIKit
import CoreData

class CreateEntryViewController: UIViewController {
    
    @IBOutlet var journalEntryTextField: UITextField!
    @IBOutlet var journalTextView: UITextView!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    
    // MARK: - iVars
    
    var entryController: EntryController?
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = journalEntryTextField.text, !title.isEmpty,
            let text = journalTextView.text, !text.isEmpty else { return }
        
        let mood = Mood.allCases[moodSegmentControl.selectedSegmentIndex]
        
        let entry = Entry(identifier: UUID().uuidString, title: title, bodyText: text, timestamp: Date(), mood: mood, context: CoreDataStack.shared.mainContext)

        entryController?.sendEntryToServer(entry: entry)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving manage object context: \(error)")
        }
    }
    
}
