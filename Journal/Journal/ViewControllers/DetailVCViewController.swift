//
//  DetailVCViewController.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//
//updated to Day-2 Standards. Found Few Flaws and errors. Thank you Jonalynn Masters for your help
import UIKit


class EntryDetailViewController: UIViewController {
    
    //MARK: Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtvBody: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let entryController = entryController,
              let title = txtTitle.text, !title.isEmpty,
              let body = txtvBody.text
        else { return }
        
        let selectedMoodIndex = segmentedControl.selectedSegmentIndex
        let mood = MoodPriority.allPriorities[selectedMoodIndex]
        
        if let entry = entry {
            entryController.updateEntry(entry, updatedTitle: title, updatedBodyText: body, updatedMood: mood.rawValue)
        } else {
            entryController.createEntry(withTitle: title, bodyText: body, mood: mood.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Journal Entry"
        txtTitle.text = entry?.title ?? ""
        txtvBody.text = entry?.bodyText ?? ""
        let mood: MoodPriority
        if let moodPriority = entry?.mood {
            mood = MoodPriority(rawValue: moodPriority)!
        } else {
            mood = .😐
        }
        segmentedControl.selectedSegmentIndex = MoodPriority.allPriorities.firstIndex(of: mood)!
    }
}
