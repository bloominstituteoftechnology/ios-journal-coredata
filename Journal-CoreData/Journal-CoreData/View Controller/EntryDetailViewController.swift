//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Nikita Thomas on 11/5/18.
//  Copyright © 2018 Nikita Thomas. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
   
    @IBAction func saveButton(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {return}
        guard let text = textView.text, !text.isEmpty else {return}
        
        var moodEmoji = ""
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            moodEmoji = Emoji.happiest.rawValue
        case 1:
            moodEmoji = Emoji.happier.rawValue
        case 2:
            moodEmoji = Emoji.happy.rawValue
        default:
            fatalError("Who knows's what's going on at this point")
        }
        
        if let entry = entry {
            entry.title = title
            entry.bodyText = text
            entry.mood = moodEmoji
        } else {
            let newEntry = Entry(title: title, bodyText: text, mood: moodEmoji)
            entryController?.put(entry: newEntry)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    var entryController: EntryController?
    
    func updateViews() {
        guard isViewLoaded else {return}
        
        title = entry?.title ?? "Create New Entry"
        titleTextField.text = entry?.title
        textView.text = entry?.bodyText
        
        switch entry?.mood {
        case Emoji.happy.rawValue:
            segmentedControl.selectedSegmentIndex = 2
        case Emoji.happier.rawValue:
            segmentedControl.selectedSegmentIndex = 1
        case Emoji.happiest.rawValue:
            segmentedControl.selectedSegmentIndex = 0
        default:
            NSLog("No emoji in entry.mood")
        }
    }

}


enum Emoji: String {
    case happiest = "🤩"
    case happier = "😁"
    case happy = "😊"
}
