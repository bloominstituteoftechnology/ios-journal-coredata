//
//  ViewController.swift
//  Journal
//
//  Created by Ian French on 6/3/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit
import CoreData

class CreateEntryViewController: UIViewController {
    
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    
    @IBOutlet weak var entryDetailTextView: UITextView!
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryTitle = entryTitleTextField.text, !entryTitle.isEmpty,
            let entryDetail = entryDetailTextView.text, !entryDetail.isEmpty else  { return }
        
        
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        let entry = Entry(title: entryTitle, mood: mood, bodyText: entryDetail, context: CoreDataStack.shared.mainContext)

        entryController?.sendEntryToServer(entry: entry)

        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
            
        }
        
    }
    
}

