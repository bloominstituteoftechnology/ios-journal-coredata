//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Hunter Oppel on 4/20/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodController: UISegmentedControl!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleTextField.becomeFirstResponder()
    }

    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
        let moodIndex = moodController.selectedSegmentIndex
        let mood = MoodProperties.allCases[moodIndex]
        
        Entry(title: title, bodyText: entryTextView.text, mood: mood)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Failed to save coredata context: \(error)")
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

