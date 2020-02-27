//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController? 
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var moodController: UISegmentedControl!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    // MARK: - ACTIONS
    
    @IBAction func save(_ sender: Any) {
        
        let index = moodController.selectedSegmentIndex
        let mood = Mood.allCases[index]
        
        
        guard let entryController = entryController, let entryTextView = entryTextView.text,
            let titleTextField = titleTextField.text else { return }
        if let entry = entry {
            entryController.updateEntry(entry: entry, title: titleTextField, bodyText: entryTextView, mood: mood)
        } else {
            entryController.createEntry(title: titleTextField, mood: mood, timeStamp: Date(), identifier: "", bodyText: entryTextView)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - METHODS
    
    override func viewDidLoad() {
           super.viewDidLoad()
           updateViews()
       }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Add Entry"
        titleTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
        if let mood = Mood(rawValue: entry?.mood ?? "😅"),
        let index = Mood.allCases.firstIndex(of: mood) {
        moodController.selectedSegmentIndex = index
        }
        
    }
    
   


}
