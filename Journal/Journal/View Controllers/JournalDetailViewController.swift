//
//  JournalDetailViewController.swift
//  Journal
//
//  Created by Farhan on 9/17/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {
    
    var entry: Journal?{
        didSet{
            updateViews()
        }
    }
    var journalController: JournalController?
    
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        
        guard let title = titleField.text, let notes = notesField.text else {return}
        guard let mood = moodControl.titleForSegment(at: moodControl.selectedSegmentIndex) else {return}
        if let entry = entry {
            journalController?.updateJournalEntry(entry: entry, with: title, and: notes, mood: mood)
        } else {
            journalController?.createJournalEntry(with: title, and: notes, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    func updateViews(){
        
        guard let entry = entry, isViewLoaded else {return}
        
        if entry.title != nil || entry.title != "" {
            title = entry.title
        } else {
            title = "New Entry"
        }
        
        titleField.text = entry.title
        notesField.text = entry.notes
        
        if entry.mood == "😁" {
            moodControl.selectedSegmentIndex = 2
        } else if entry.mood == "☹️" {
            moodControl.selectedSegmentIndex = 0
        } else if entry.mood == "😐"{
            moodControl.selectedSegmentIndex = 1
        }
        
        
    }
    

}
