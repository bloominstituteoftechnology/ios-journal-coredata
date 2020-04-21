//
//  ViewController.swift
//  Journal
//
//  Created by Mark Poggi on 4/20/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - Properties
    
    var complete = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodEmojiControl: UISegmentedControl!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem){
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func save(_ sender: UIBarButtonItem){
        
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        let bodyText = entryTextView.text ?? ""
        let moodIndex = moodEmojiControl.selectedSegmentIndex
        let mood = MoodPriority.allCases[moodIndex]
        let timestamp = Date()
        
        Entry(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

