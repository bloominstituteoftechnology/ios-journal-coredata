//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jeremy Taylor on 6/3/19.
//  Copyright © 2019 Bytes Random L.L.C. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    enum Mood: String {
        case sad = "☹️"
        case neutral = "😐"
        case happy = "😀"
        
        static var allMoods: [Mood] {
            return [.sad, .neutral, .happy]
        }
    }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let entryTitle = titleTextField.text,
            !entryTitle.isEmpty,
        let entryText = textView.text,
            !entryText.isEmpty else { return }
        let mood = Mood.allMoods[moodSegmentedControl.selectedSegmentIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, title: entryTitle, bodyText: entryText, mood: mood.rawValue)
        } else {
            entryController?.createEntry(title: entryTitle, bodyText: entryText, mood: mood.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        guard let moodString = entry?.mood else { return }
        
        let mood = Mood(rawValue: moodString)!
        
        moodSegmentedControl.selectedSegmentIndex = Mood.allMoods.firstIndex(of: mood)!
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        textView.text = entry?.bodyText
        
    }
}
