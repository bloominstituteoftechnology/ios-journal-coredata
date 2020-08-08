//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by ronald huston jr on 7/19/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var diaryTextView: UITextView!
    @IBOutlet weak var moodSelector: UISegmentedControl!
    var wasEdited: Bool = false
    
    
    //  MARK: - view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = entryTextField.text,
                !title.isEmpty,
                let bodyText = diaryTextView.text,
                !bodyText.isEmpty,
                let entry = entry else {
                    return
            }
            
            entry.title = title
            entry.bodyText = bodyText
            entry.timestamp = Date()
            let moodFace = moodSelector.selectedSegmentIndex
            entry.mood = Mood.allCases[moodFace].rawValue
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("error saving managed object context: \(error)")
            }
        }
    }
    
    //  MARK: - editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        entryTextField.isUserInteractionEnabled = editing
        diaryTextView.isUserInteractionEnabled = editing
        moodSelector.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        entryTextField.text = entry?.title
        entryTextField.isUserInteractionEnabled = isEditing
        
        diaryTextView.text = entry?.bodyText
        diaryTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        
        if let moodPrior = entry?.mood {
            mood = Mood(rawValue: moodPrior)!
        } else {
            mood = .😀
        }
        
        moodSelector.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodSelector.isUserInteractionEnabled = isEditing
    }

}
