//
//  EntryDetailViewController.swift
//  JournalCDHWRepeat
//
//  Created by Michael Flowers on 6/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            print("Entry was set")
            updateViews()
        }
    }
    var ec: EntryController? {
        didSet {
            print("EC was set")
        }
    }

    @IBOutlet weak var segmentProperties: UISegmentedControl!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bodyTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveEntry(_ sender: UIBarButtonItem) {
        guard let title = titleTF.text, !title.isEmpty, let body = bodyTV.text, !body.isEmpty, let ec = ec else { print("Something wrong"); return }
        let segmentedIndex = segmentProperties.selectedSegmentIndex
        let mood = EntryMood.allMoods[segmentedIndex]
        
        if let passedInEntry = entry {
            //update entry
            ec.update(entry: passedInEntry, newTitle: title, newBody: body, newMood: mood)
        } else {
            //create a new entry
            ec.createEntry(title: title, bodyText: body, mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews(){
        guard let passedInEntry = entry, isViewLoaded else { title = "Create Entry"; return }
        titleTF.text = passedInEntry.title
        bodyTV.text = passedInEntry.bodyText
        title = passedInEntry.title
        
        if let entryMood = passedInEntry.mood, let mood = EntryMood(rawValue: entryMood){
            segmentProperties.selectedSegmentIndex = EntryMood.allMoods.firstIndex(of: mood) ?? 0
        }
    }
}
