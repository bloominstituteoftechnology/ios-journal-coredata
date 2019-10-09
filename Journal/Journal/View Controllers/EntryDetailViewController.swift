//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Vici Shaweddy on 10/2/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    
    var entryController: EntryController?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        self.textField.text = entry?.title
        self.textView.text = entry?.bodyText
        
        if entry == nil {
            self.navigationItem.title = "Create Entry"
        } else {
            self.navigationItem.title = entry?.title
        }
        
        var mood: EntryMood
        if let moodString = entry?.mood, let entryMood = EntryMood(rawValue: moodString) {
            mood = entryMood
        } else {
            mood = .okay
        }
        
        if let index = EntryMood.allCases.firstIndex(of: mood) {
            moodSegmentedControl.selectedSegmentIndex = index
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let title = self.textField.text, !title.isEmpty else { return }
        
        // for mood segmented control
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        
        let bodyText = self.textView.text
        
        if let entry = entry {
            entryController?.update(entry: entry, mood: mood.rawValue, title: title, bodyText: bodyText ?? "")
        } else {
            entryController?.create(mood: mood, title: title, bodyText: bodyText)

        }
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
