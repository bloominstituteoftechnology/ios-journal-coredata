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
    
    var entryController: EntryController?
    var entry: Entry?
    var wasEdited: Bool = false
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.tintColor = .black
      updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           if wasEdited {
               guard let title = titleTextField.text,
                   !title.isEmpty,
                   let entry = entry else { return }
               
               let bodytext = bodyTextView.text
               entry.title = title
               entry.bodyText = bodytext
               let moodIndex = moodSegControl.selectedSegmentIndex
               entry.mood = EntryMood.allCases[moodIndex].rawValue
               entryController?.sendEntryToServer(entry: entry)
               
               do {
                   try CoreDataStack.shared.mainContext.save()
               } catch {
                   NSLog("Error saving managed object context")
               }
           }
       }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
           super.setEditing(editing, animated: animated)
           
           if editing { wasEdited = true }
           
           titleTextField.isUserInteractionEnabled = editing
           bodyTextView.isUserInteractionEnabled = editing
           moodSegControl.isUserInteractionEnabled = editing
           navigationItem.hidesBackButton = editing
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
