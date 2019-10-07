//
//  EntryDetailViewController.swift
//  MyJournal
//
//  Created by Eoin Lavery on 02/10/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import UIKit

enum Moods: Int, CaseIterable {
    case sad = 0
    case neutral = 1
    case happy = 2
    
    var moodName: String {
        switch self {
        case .sad:
            return "☹️"
        case .neutral:
            return "😐"
        case .happy:
            return "😄"
        }
    }
}

class EntryDetailViewController: UIViewController {

    //MARK: - IBOUTLETS
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: - PROPERTIES
    var selectedMood: Moods?
    var entriesController: EntriesController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    //MARK: - PRIVATE FUNCTIONS
    private func updateViews() {
        guard isViewLoaded else { return }
        
        guard let entry = entry else {
            title = "New Entry"
            moodSegmentedControl.selectedSegmentIndex = 1
            selectedMood = .neutral
            saveButton.isEnabled = false
            return
        }
        
        title = entry.name
        titleTextField.text = entry.name
        notesTextView.text = entry.bodyText
        
        switch entry.mood {
        case "☹️":
            selectedMood = .sad
            moodSegmentedControl.selectedSegmentIndex = 0
        case "😐":
            selectedMood = .neutral
            moodSegmentedControl.selectedSegmentIndex = 1
        case "😄":
            selectedMood = .happy
            moodSegmentedControl.selectedSegmentIndex = 2
        default:
            selectedMood = .neutral
            moodSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func textEditingDidChange(_ sender: Any) {
        if let name = titleTextField.text, !name.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    private func updateMood() {
        switch moodSegmentedControl.selectedSegmentIndex {
        case 0:
            selectedMood = .sad
        case 1:
            selectedMood = .neutral
        case 2:
            selectedMood = .happy
        default:
            selectedMood = .neutral
        }
    }
    
    //MARK: - IBACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = titleTextField.text,
            let bodyText = notesTextView.text,
            let mood = selectedMood,
            !name.isEmpty else { return }
        
        if let entry = entry {
            entriesController?.updateEntry(name: name, bodyText: bodyText, mood: mood.moodName, entry: entry)
        } else {
            entriesController?.createEntry(name: name, bodyText: bodyText, mood: mood.moodName)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moodValueChanged(_ sender: Any) {
        updateMood()
    }
    
    
}
