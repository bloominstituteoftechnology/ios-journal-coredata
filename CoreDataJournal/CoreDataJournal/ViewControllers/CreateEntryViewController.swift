//
//  CreateEntryViewController.swift
//  CoreDataJournal
//
//  Created by Marissa Gonzales on 5/18/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - Properties
    var entryController: EntryController?
    
    // MARK: - Outlets
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var entryDetailTextField: UITextView!
    @IBOutlet weak var entryTitleTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func save(_ sender: UIButton) {
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        guard let entryTitle = entryTitleTextField.text,
            !entryTitle.isEmpty else { return }
        
        guard let entryDetail = entryDetailTextField.text,
            !entryDetail.isEmpty else { return }
        
        let entry = Entry(title: entryTitle, bodyText: entryDetail, mood: mood, context: CoreDataStack.shared.mainContext)
        entryController?.sendEntryToServer(entry: entry)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

