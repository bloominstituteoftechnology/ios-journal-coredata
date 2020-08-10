//
//  ViewController.swift
//  Journal
//
//  Created by Dojo on 8/5/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var moodSegementedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = entryTextField.text,
            !title.isEmpty,
            
            let bodyText = descriptionTextView.text, !bodyText.isEmpty else { return }
        
         let mood = Mood.allCases[moodSegementedController.selectedSegmentIndex]
        Entry(bodyText: bodyText, timestamp: Date(), mood: mood, title: title, context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
}
