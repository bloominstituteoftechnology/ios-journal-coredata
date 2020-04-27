//
//  ViewController.swift
//  Journal
//
//  Created by Thomas Dye on 4/22/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMoodSegmentedControl()
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
        // Get values from the views
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        let bodyText = bodyTextView.text
        
        // Create the context
        Entry(title: title,
              bodyText: bodyText,
              timestamp: Date(),
              context: CoreDataStack.shared.mainContext)
        
        // do try catch to save the context we have created
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving manage object context: \(error)")
        }
    }
    
    func setUpMoodSegmentedControl() {
        moodSegmentedControl.setTitle("😢", forSegmentAt: 0)
        moodSegmentedControl.setTitle("😐", forSegmentAt: 1)
        moodSegmentedControl.setTitle("😊", forSegmentAt: 2)
    }
}

