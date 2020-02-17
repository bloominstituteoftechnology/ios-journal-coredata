//
//  JournalDetailViewController.swift
//  Journal
//
//  Created by Eoin Lavery on 13/02/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit
import CoreData

class JournalDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    //MARK: - Properties
    let entryController = EntryController.shared
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        nameTextField.delegate = self
    }
    
    //Private Functions
    private func saveEntry() {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        
        let notes = notesTextView.text
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        guard let mood = moodSegmentedControl.titleForSegment(at: moodIndex) else { return }
        
        if let entry = entry {
            entryController.updateEntry(for: entry, with: name, notes: notes, date: Date(), mood: mood)
        } else {
            entryController.createEntry(with: name, notes: notes, date: Date(), mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    private func updateViews() {
        guard isViewLoaded else {
            return
        }
        
        if let entry = entry {
            title = entry.name
            nameTextField.text = entry.name
            notesTextView.text = entry.notes
            
            let mood = entry.mood
            
            switch mood {
            case "😔":
                moodSegmentedControl.selectedSegmentIndex = 0
            case "😐":
                moodSegmentedControl.selectedSegmentIndex = 1
            case "☺️":
                moodSegmentedControl.selectedSegmentIndex = 2
            default:
                moodSegmentedControl.selectedSegmentIndex = 1
            }
            
        } else {
            saveButton.isEnabled = false
        }
        
    }
    
    //MARK: - IBActions
    @IBAction func savePressed(_ sender: Any) {
        saveEntry()
    }

    @IBAction func titleLabelEditingDidEnd(_ sender: Any) {
        if nameTextField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }

}

extension JournalDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
    
}

extension JournalDetailViewController: UITextViewDelegate {
    
    
    
}
