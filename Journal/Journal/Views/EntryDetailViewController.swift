//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Bobby Keffury on 10/2/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodConntrol: UISegmentedControl!
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        
        var mood: EntryPriority
        if let entryPriorityString = entry?.mood, let entryPriority = EntryPriority(rawValue: entryPriorityString) {
            mood = entryPriority
        } else {
            mood = .😐
        }
        if let index = EntryPriority.allCases.firstIndex(of: mood) {
            moodConntrol.selectedSegmentIndex = index
        }
        
        titleTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        guard let title = titleTextField.text, !title.isEmpty, let bodyText = entryTextView.text else { return }
        
        let moodIndex = moodConntrol.selectedSegmentIndex
        let mood = EntryPriority.allCases[moodIndex]
//        guard let mood = moodConntrol.titleForSegment(at: moodIndex) else { return }
        
        
        if let entry = entry {
            entryController?.Update(title: title, bodyText: bodyText, entry: entry, mood: mood.rawValue)
        } else {
            entryController?.Create(title: title, bodyText: bodyText, mood: mood.rawValue)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
