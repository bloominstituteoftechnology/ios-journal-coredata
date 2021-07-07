//
//  ViewController.swift
//  Journal
//
//  Created by Rick Wolter on 11/11/19.
//  Copyright © 2019 Richard Wolter. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet{
            updateViews()        }
    }
    
    @IBOutlet private weak var entryTitleTextField: UITextField!
    @IBOutlet private weak var entryBodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    
      override func viewDidLoad() {
           super.viewDidLoad()
           updateViews()
       }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryTitle = entryTitleTextField.text, !entryTitle.isEmpty else {return}
        let entryBody = entryBodyTextView.text
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        guard let moodString = moodSegmentedControl.titleForSegment(at: moodIndex) else {return}
       
        if let entry = entry {
            entry.title = entryTitle
            entry.bodyText = entryBody
            entry.mood = moodString
        } else {
            print("There should be a mood string here \(moodString)")
            let _ = Entry(title: entryTitle, bodyText: entryBody, timestamp: Date.init(),  indentifier: nil, mood: Mood(rawValue: moodString)! )
        }
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context \(error)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else {return}
        title = entry?.title ?? "Create an Entry"
        entryTitleTextField.text = entry?.title
        entryBodyTextView.text = entry?.bodyText
        
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        guard let moodString = moodSegmentedControl.titleForSegment(at: moodIndex) else {return}
        
      
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .😐
        }
        moodSegmentedControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood)!
    }
}

