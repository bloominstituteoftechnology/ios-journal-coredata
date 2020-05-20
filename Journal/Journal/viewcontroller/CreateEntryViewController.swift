//
//  ViewController.swift
//  Journal
//
//  Created by Vincent Hoang on 5/18/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let title = titleTextField.text ?? ""
        let body = bodyTextView.text ?? ""
        
        if !title.isEmpty {
            Entry(title: title, bodyText: body, timeStamp: Date(), mood: getMood())
            do {
                try CoreDataStack.shared.mainContext.save()
                dismiss(animated: true, completion: nil)
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        titleTextField.resignFirstResponder()
        bodyTextView.resignFirstResponder()
        
        NSLog("User initiated cancel action. Dismissing view")
        dismiss(animated: true, completion: nil)
    }
    
    private func getMood() -> Mood {
        switch moodSegmentedControl.selectedSegmentIndex {
        case 0:
            return Mood.happy
        case 1:
            return Mood.neutral
        case 2:
            return Mood.unhappy
        default:
            NSLog("moodSegmentedControl did not return a proper index value; Default value used")
            return Mood.neutral
        }
    }
}

