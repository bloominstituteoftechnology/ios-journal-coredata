//
//  ViewController.swift
//  iosJournalProject
//
//  Created by BrysonSaclausa on 8/5/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import CoreData

class CreateEntryViewController: UIViewController {
    
    // MARK: - Properties
    
    var entryController: EntryController?
    
    // MARK: - IBOutlets
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var emojiSementedControl: UISegmentedControl!
    
    // MARK: - View Lifecycle


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated:true, completion: nil)

    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let title = entryTitleTextField.text,
            !title.isEmpty,
            let bodyText = bodyTextView.text,
            !bodyText.isEmpty else { return }
        let moodIndex = emojiSementedControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        let entry = Entry(title: title, timestamp: Date(), bodyText: bodyText, mood: mood)
        
        entryController?.sendEntryToServer(entry: entry)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context \(error)")
        }
    }
    
}

