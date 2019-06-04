//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Hayden Hastings on 6/3/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let entry = entry {
            titleTextField.text = entry.title
            journalTextView.text = entry.bodyText
            title = entry.title
        } else {
            title = "Create Entry"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = journalTextView.text, !bodyText.isEmpty else { return }
        
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = Mood.allMoods[moodIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
        } else {
            entryController?.create(journal: title, bodyText: bodyText, timestamp: Date(), identifier: UUID().uuidString, mood: mood.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
}
