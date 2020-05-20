//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by ronald huston jr on 5/19/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    //  MARK: - properties
    var entry: Entry?
    var wasEdited: Bool = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        
        updateViews()
    }
    

    func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        bodyTextView.text = entry?.bodyText
        bodyTextView.isUserInteractionEnabled = isEditing
        
        let presentMood: Mood
        if let setMood = entry?.mood {
            presentMood = Mood(rawValue: setMood)!
        } else {
            presentMood = .happy
        }
        moodSegmentControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: presentMood) ?? 1
        moodSegmentControl.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        bodyTextView.isUserInteractionEnabled = editing
        moodSegmentControl.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = titleTextField.text,
                !title.isEmpty,
                let entry = entry else {
                    return
            }
            
            let bodyText = bodyTextView.text
            entry.title = title
            entry.bodyText = bodyText
            
            let mood = moodSegmentControl.selectedSegmentIndex
            entry.mood = Mood.allCases[mood].rawValue
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("error saving managed object context: \(error)")
            }
        }
    }
}
