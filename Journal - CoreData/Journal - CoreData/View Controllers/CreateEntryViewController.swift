//
//  EntryDetailViewController.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
//        viewDidLoad()
        
        if ((entry?.title) != nil)  {
        self.title = entry?.title
        } else {
            self.title = "Create Entry"
        }
        
        if entry != nil {
            titleTextField.text = entry?.title
            entryTextView.text = entry?.bodyText
            let moodIndex = moodControl.selectedSegmentIndex
            let mood = EntryMood.allCases[moodIndex].rawValue
            entry?.mood = mood
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
       guard let entryText = entryTextView.text,
        !entryText.isEmpty else { return }
        let date = Date()
        
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        let entry = Entry(title: title, timestamp: date, mood: mood)
        entryController?.sendEntryToServer(entry: entry)
        
//        if entry != nil {
//            entryController?.update(title: title, timestamp: date, bodyText: entryText, mood: mood.rawValue)
//        } else {
//            entryController?.create(title: title, timestamp: date, bodyText: entryText, mood: mood.rawValue)
//        }
//
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
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
