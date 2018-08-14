//
//  EntryDetailViewController.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/13/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title
        textView.text = entry?.bodyText
        guard let entryMood = entry?.mood,
            let mood = Mood(rawValue: entryMood) else { return }
        
        moodSegmentedControl.selectedSegmentIndex = Mood.allMoods.index(of: mood)!
    }

    @IBAction func save(_ sender: Any) {
        guard let textField = textField.text,
            let textView = textView.text,
            let msc = moodSegmentedControl else { return }
        
        let currentMood = msc.titleForSegment(at: msc.selectedSegmentIndex) ?? "😐"
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: textField, bodyText: textView, mood: currentMood)
            entryController?.saveToPersistentStore()
        } else {
            entryController?.createEntry(title: textField,
                                         identifier: UUID().uuidString,
                                         bodyText: textView,
                                         mood: currentMood)
            entryController?.saveToPersistentStore()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
}
