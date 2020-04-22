//
//  EntryDetailViewController.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/21/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var entry: Entry?
    var wasEdited = false
    
     // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        let mood: EntryMood
        if let entryMood = entry?.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .😐
        }
        
        moodControl.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood) ?? 1
        moodControl.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
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
