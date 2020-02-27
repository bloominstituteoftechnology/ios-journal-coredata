//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Tobi Kuyoro on 27/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = entryTextField.text,
            let bodyText = entryTextView.text else { return }
        
        let index = moodSegmentControl.selectedSegmentIndex
        let mood = Mood.allCases[index]
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, called: title, bodyText: bodyText, timeStamp: entry.timeStamp ?? Date(), identifier: entry.identifier ?? "", mood: mood.rawValue)
        } else {
            entryController?.createEntry(called: title, bodyText: bodyText, timeStamp: Date(), identifier: "", mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        entryTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
        
        if let moodString = entry?.mood {
            if let mood = Mood(rawValue: moodString) {
                let index = Mood.allCases.firstIndex(of: mood) ?? 1
                moodSegmentControl.selectedSegmentIndex = index
            }
        }
    }
}
