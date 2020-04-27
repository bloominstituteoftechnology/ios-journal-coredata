//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/22/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - Properties
    var timestamp = NSDate.now
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = bodyTextView.text,
            !bodyText.isEmpty else { return }
        
        let selectedMood = moodControl.selectedSegmentIndex
        let mood = Mood.allCases[selectedMood]
        
        Entry(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context \(error)")
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
