//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/10/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    
    var entryController: EntryController?
    
    var entries: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        view.backgroundColor = ColorHelper.backgroundColorNew
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let entryName = self.titleTextField.text,
            !entryName.isEmpty else {return}
        
        let moodIndex = moodSegmentControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        let bodyText = self.detailView.text
        
        if let entry = self.entries {
            entry.title = entryName
            entry.mood = mood.rawValue
            entry.bodyText = bodyText
            entryController?.put(entry: entry)
            
        } else {
            let entry = Entry(title: entryName, bodyText: bodyText!, mood: mood)
            entryController?.put(entry: entry)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error Saving manged object context: \(error)")
        }
//        guard let titleEntry = titleTextField.text,
//            let detailEntry = detailView.text else {return}
//
//        let moodIndex = moodSegmentControl.selectedSegmentIndex
//        let mood = EntryMood.allCases[moodIndex]
//
//
//        if let entry = entries {
//            entryController?.update(entry: entry, title: titleEntry, bodyText: detailEntry, mood: mood)
//            entry.mood = mood.rawValue
//        } else {
//            entryController?.createEntry(title: titleEntry, bodyText: detailEntry)
//        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews(){
        guard isViewLoaded else {return}
        
        let mood: EntryMood
        if let entryMood = entries?.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .😐
        }
        moodSegmentControl.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood)!
        
        self.navigationItem.title = entries?.title ?? "Entry"
        titleTextField.text = entries?.title
        detailView.text = entries?.bodyText
    }

}
