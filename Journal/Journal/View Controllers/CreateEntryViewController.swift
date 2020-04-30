//
//  ViewController.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/22/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    //MARK: - Properties and IBOutlets -
    
    var entryController: EntryController?
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
    
    //MARK: - Methods and IBOutlets -
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let body = bodyTextView.text,
            !title.isEmpty,
            !body.isEmpty else { return }
        
        let index = moodSegmentedControl.selectedSegmentIndex
        var mood = "😐"
        
        if index == 0 {
            mood = Mood.sad.rawValue
        } else if index == 1 {
            mood = Mood.neutral.rawValue
        } else if index == 2 {
            mood = Mood.happy.rawValue
        }
        
        let entry = Entry(title: title, bodyText: body, timestamp: Date(), mood: mood, context: CoreDataStack.shared.mainContext)
        
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Could not save new user entry: \(error)")
        }
        
        entryController?.sendEntryToServer(entry: entry, completion: { _ in })
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
} //End of class

