//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Paul Yi on 2/18/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func save(_ sender: Any) {
        guard let title = textField.text,
            let bodyText = textView.text else { return }
        
        let selectedMood = EntryMood.allMoods[segmentedControl.selectedSegmentIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: selectedMood)
        } else {
            entryController?.create(title: title, bodyText: bodyText, mood: selectedMood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title
        textView.text = entry?.bodyText
        
        guard let moodString = entry?.mood,
            let mood = EntryMood(rawValue: moodString) else { return }
        
        segmentedControl.selectedSegmentIndex = EntryMood.allMoods.index(of: mood)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
}
