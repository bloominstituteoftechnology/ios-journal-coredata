//
//  EntryViewController.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit


class EntryViewController: UIViewController {
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }

    private func updateViews() {
        if isViewLoaded {
            
            guard let entry = entry else {
                title  = "Create Entry"
                titleTextField.becomeFirstResponder()
                return
            }
            
            let mood: Mood
            if let entryMood = entry.mood {
                mood = Mood(rawValue: entryMood)!
            } else {
                mood = .🧐
            }
            title = entry.title
            titleTextField.text = entry.title
            journalTextView.text = entry.bodyText
            moodSegmentedControl.selectedSegmentIndex = Mood.allMoods.firstIndex(of: mood)!
        }
    }
    
    
    
    
    
    
    
    @IBAction func saveJournalButtonPressed(_ sender: Any) {
        
        guard let title = titleTextField.text, !title.isEmpty else {
            NSLog ("No title set")
            return
        }
        
        let textInput = journalTextView.text ?? ""
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allMoods[moodIndex]
        
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: textInput, mood: mood )
        } else {
            entryController?.createEntry(title: title, bodyText: textInput, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)


    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
