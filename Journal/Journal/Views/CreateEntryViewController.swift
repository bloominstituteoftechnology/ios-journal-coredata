//
//  ViewController.swift
//  Journal
//
//  Created by Breena Greek on 4/22/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var bodyTextTextField: UITextView!
    
    // MARK: - IBActions
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let body = bodyTextTextField.text,
            !body.isEmpty else { return }
        
        let selectedMood = moodControl.selectedSegmentIndex
        let mood = Mood.allCases[selectedMood]
        
        Entry(title: title,
              bodyText: body,
              mood: mood,
              context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving Entry to persistent store: \(error)")
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

