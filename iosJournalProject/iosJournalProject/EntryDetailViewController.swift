//
//  EntryDetailViewController.swift
//  iosJournalProject
//
//  Created by BrysonSaclausa on 8/8/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var entry: Entry?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
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
        
        let mood: EntryMood
        if let entryMood = entry?.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .neutral
            
        }
        
        moodSegControl.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood) ?? 1
        moodSegControl.isUserInteractionEnabled = isEditing
        
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
