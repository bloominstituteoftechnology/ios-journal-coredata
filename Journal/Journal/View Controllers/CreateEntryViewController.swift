//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Cameron Collins on 4/20/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Variables
    var entryController: EntryController?
    
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let mood = MoodType.allCases[moodSegmentedControl.selectedSegmentIndex]
        let entry = Entry(title: titleTextField.text!, bodyText: bodyTextView.text, mood: mood)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
            return
        }
        
        //Send Entry to Server
        if let entryController = entryController {
            print("Calling SendTaskToServer")
            entryController.sendTaskToServer(entry: entry) {
                print("Finished Sending")
            }
        } else {
            print("Entry Controller is null")
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

