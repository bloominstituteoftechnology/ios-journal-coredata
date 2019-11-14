//
//  EntryDetailViewController.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit
import CoreData

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties & Outlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
//    var entryController: EntryController? // still something wrong with accessing the database // getting Nil error if ! is used, Firebase does not record w/ ?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    // MARK: - Methods

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text else { return }
        guard let description = descriptionTextView.text else { return }
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
            // Creating New Entries / Updating
        if let entry = entry { // edit existing journal entry
            entry.title = title
            entry.bodyText = description
            entry.mood = mood.rawValue
            entry.timeStamp = Date()
//            entryController?.put(entry: entry)
            EntryController.put(entry: entry)
        } else { // Create new Journal Entry:
            let entry = Entry(title: title, bodyText: description, mood: mood, identifier: "", timeStamp: Date())
//            entryController?.put(entry: entry)
            EntryController.put(entry: entry)
        }
        
        saveToPersistentStore()
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Journal Entry"
        titleTextField.text = entry?.title
        descriptionTextView.text = entry?.bodyText
        let setMood: Mood
        if let mood = entry?.mood {
            setMood = Mood(rawValue: mood)!
        } else {
            setMood = .🧐
        }
        
        moodControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: setMood)!
    }
    
    // Saving them in the Database
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    
    
}
