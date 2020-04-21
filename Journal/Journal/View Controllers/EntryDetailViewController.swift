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
        
//        moodSegmentedControl.selectedSegmentIndex = entry. // TODO: show selected segment in detail view
        journalEntryTitleLabel.text = entry.title
        journalEntryBodyLabel.text = entry.bodyText
    }
    
}
