//
//  EntryDetailTableViewController.swift
//  Journal
//
//  Created by macbook on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    //MARK: Properties
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
    
    //MARK: Save Button
    @IBAction func saveBarButton(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty,
            !bodyText.isEmpty else { return }
        
        let index = moodSegmentedControl.selectedSegmentIndex
        let mood: EntryMood
        
        // Chenging the Entry mood
        switch index {
        case 0:
            mood = .sad
        case 1:
            mood = .neutral
        case 2:
            mood = .happy
        default:
            mood = .neutral
        }
        
            // Either save a new task or update the existing task
            if let entry = entry {
                entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
            } else {
                entryController?.createEntry(title: title, bodyText: bodyText, mood: mood.rawValue)
            }
        
        navigationController?.popViewController(animated: true)

    }
    
    //MARK: UpdateViews()
    func updateViews() {
        guard isViewLoaded else { return }
    
            title = entry?.title ?? "Create New Entry"
            titleTextField.text = entry?.title
            bodyTextView.text = entry?.bodyText

    }
}
