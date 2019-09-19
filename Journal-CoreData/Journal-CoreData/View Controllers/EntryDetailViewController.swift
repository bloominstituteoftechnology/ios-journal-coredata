//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Ciara Beitel on 9/16/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

enum Mood: String, CaseIterable {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "🙂"
}

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var storyTextView: UITextView!
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let titleTextField = titleTextField.text, let storyTextView = storyTextView.text else { return }
        
        let index = moodSegmentedControl.selectedSegmentIndex
        
        let mood = Mood.allCases[index]
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: titleTextField, bodyText: storyTextView, mood: mood.rawValue)
        } else {
            var _ = entryController?.createEntry(title: titleTextField, bodyText: storyTextView, timestamp: Date(), identifier: UUID(), mood: mood.rawValue)
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        if isViewLoaded {
            title = entry?.title ?? "Create Entry"
            titleTextField.text = entry?.title
            storyTextView.text = entry?.bodyText
            
            if let moodString = entry?.mood,
                let mood = Mood(rawValue: moodString) {
                let index = Mood.allCases.firstIndex(of: mood) ?? 1
                moodSegmentedControl.selectedSegmentIndex = index
            }
        }
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


