//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Shawn James on 4/21/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var journalEntryTitleLabel: UITextField!
    @IBOutlet weak var journalEntryBodyLabel: UITextView!
    
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        let mood: EntryMood
        if let entryMood = entry.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .b
        }
        
        moodSegmentedControl.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood) ?? 1
        journalEntryTitleLabel.text = entry.title
        journalEntryBodyLabel.text = entry.bodyText
    }
    
}
