//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!

    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let entryController = entryController,
            let title = entryTitleTextField.text,
            let body = entryBodyTextView.text
            else { return }
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allMoods[moodIndex]
        
        if let entry = entry {
            entryController.update(entry: entry, title: title, bodyText: body, mood: mood.rawValue)
        } else {
            entryController.create(title: title, bodyText: body, mood: mood.rawValue, timeStamp: Date(), identifier: "")
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        entryTitleTextField.text = entry?.title
        
        let mood: Mood
        if let entryMood = entry?.mood,
            let moods = Mood(rawValue: entryMood){
            mood = moods
        } else {
            mood = .neutral
        }
            
        let moodIndex = Mood.allMoods.firstIndex(of: mood)!
        moodSegmentedControl.selectedSegmentIndex = moodIndex
        
        entryBodyTextView.text = entry?.bodyText
    }

}
