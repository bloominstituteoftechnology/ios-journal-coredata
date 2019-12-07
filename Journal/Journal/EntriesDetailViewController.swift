//
//  EntriesDetailViewController.swift
//  Journal
//
//  Created by Alex Thompson on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntriesDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var moodChange: UISegmentedControl!
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if let title = titleTextField.text,
            let bodyTitle = journalTextView.text {
            
            let index = moodChange.selectedSegmentIndex
            
            let mood: Mood
            
            if index == 0 {
                mood = .😭
            } else if index == 1 {
                mood = .😠
            } else {
                mood = .🙂
            }
            
            if let entry = entry {
                entryController?.updateEntry(entry: entry, with: title, bodyTitle: bodyTitle, mood: mood)
            } else {
                entryController?.createEntry(with: title, bodyTitle: bodyTitle, mood: mood, context: CoreDataStack.shared.mainContext)
            }
        }
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        journalTextView.layer.cornerRadius = 8
        greyView.backgroundColor = .gray
        

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        journalTextView.text = entry?.bodyTitle
        
        if let mood = Mood(rawValue: entry?.mood ?? "😠"),
            let moodIndex = Mood.allCases.firstIndex(of: mood) {
            moodChange.selectedSegmentIndex = moodIndex
        }
    }
}
