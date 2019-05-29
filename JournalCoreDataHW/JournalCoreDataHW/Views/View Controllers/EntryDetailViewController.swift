//
//  EntryDetailViewController.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit



class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var ec: EntryController?

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bodyTV: UITextView!
    @IBOutlet weak var segmentedProperties: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleTF.text, !title.isEmpty, let body = bodyTV.text, !body.isEmpty else { return }
        
        //get the priority from the segmented control
        let moodIndex = segmentedProperties.selectedSegmentIndex
        //because the enum and the segmented control are in order we can use the segmented index and subscript the array
        let mood = EntryMood.allMoods[moodIndex].rawValue
        
//        var mood = ""
//        let index = segmentedProperties.selectedSegmentIndex
//        switch index {
//        case 0:
//            mood = EntryMood.happy.rawValue
//        case 1:
//            mood = EntryMood.chillin.rawValue
//        case 2:
//            mood = EntryMood.sad.rawValue
//        default:
//            break
//        }
        
        guard let passedInEntry = entry else {
            //create new entry
            ec?.createEntry(title: title, bodyText: body, mood: mood)
            navigationController?.popViewController(animated: true)
            return
        }
        //udpate
        ec?.update(entry: passedInEntry, newTitle: title, newBodyText: body, newTimestamp: Date(), newMood: mood)
        navigationController?.popViewController(animated: true)
        
    }
    
    private func updateViews(){
        guard let passedInEntry = entry, isViewLoaded else {
            title = "Create Entry"
            return }
        titleTF.text = passedInEntry.title
        bodyTV.text = passedInEntry.bodyText
        title = passedInEntry.title
        
        if let entryMood = passedInEntry.mood, let mood = EntryMood(rawValue: entryMood) {
            segmentedProperties.selectedSegmentIndex = EntryMood.allMoods.firstIndex(of: mood) ?? 0 
        }
        
    }
}
