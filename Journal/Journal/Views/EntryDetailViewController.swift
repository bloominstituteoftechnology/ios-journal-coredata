//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Joel Groomer on 10/2/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: JournalEntry? { didSet { updateViews() } }
    var entryController: EntryController?
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtvBody: UITextView!
    @IBOutlet weak var segMood: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    @IBAction func saveTapped(_ sender: Any) {
        guard let entryController = entryController,
            let title = txtTitle.text, !title.isEmpty,
            let body = txtvBody.text,
            let moodString = segMood.titleForSegment(at: segMood.selectedSegmentIndex)
        else { return }
        
        var mood = EntryMood.meh   // default to neutral value
        for m in EntryMood.allCases {
            if m.stringValue == moodString {
                mood = m
                break
            }
        }
        
        if let entry = entry {
            entryController.updateEntry(entry: entry, newTitle: title, newBody: body, newMood: mood)
        } else {
            entryController.createEntry(title: title, body: body, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Journal Entry"
        txtTitle.text = entry?.title ?? ""
        txtvBody.text = entry?.bodyText ?? ""
        let moodString = entry?.mood ?? EntryMood.meh.stringValue
        var moodIndex = 1   // default to neutral value
        var i = 0
        for m in EntryMood.allCases {
            if m.stringValue == moodString {
                moodIndex = i
                break
            }
            i += 1
        }
        segMood.selectedSegmentIndex = moodIndex
    }

}
