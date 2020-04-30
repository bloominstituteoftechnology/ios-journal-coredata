//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by David Williams on 4/24/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    
    var entry: Entry? 
    var wasEdited: Bool = false
    
     var entryController: EntryContoller?
    
    @IBOutlet weak var journalTitle: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeValue(sender: segmentedControl)
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
        journalTitle.clearsOnBeginEditing = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = journalTitle.text,
                let body = entryTextView.text,
                !title.isEmpty,
                !body.isEmpty,
                let entry = entry else { return }
            
            let selectedMood = segmentedControl.selectedSegmentIndex
            
            let mood = Mood.allCases[selectedMood]
            
            // Update the entry that already exists
            entry.title = title
            entry.bodyText = body
            entry.mood = mood.rawValue
            entryController?.put(entry: entry, completion: { _ in })
            do {
                try CoreDataStack.shared.mainContext.save()
                //       navigationController?.dismiss(animated: true)
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        } 
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
       
            journalTitle.isUserInteractionEnabled = editing
            entryTextView.isUserInteractionEnabled = editing
            segmentedControl.isUserInteractionEnabled = editing
            navigationItem.hidesBackButton = editing
    }
    
    func updateViews() {
        var indexMatched: Int = 0
        journalTitle.text = entry?.title
        journalTitle.isUserInteractionEnabled = isEditing
        
        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        segmentedControl.isUserInteractionEnabled = isEditing
        switch entry?.mood {
        case "😀":
            indexMatched = 0
             segmentedControl.selectedSegmentTintColor = UIColor.green
        case "😫":
            indexMatched = 1
            segmentedControl.selectedSegmentTintColor = UIColor.brown
        case "😐":
            indexMatched = 2
            segmentedControl.selectedSegmentTintColor = UIColor.orange
        default:
            break
        }
        segmentedControl.selectedSegmentIndex = indexMatched
    }

    func changeValue(sender: UISegmentedControl) {
          let i = sender.selectedSegmentIndex
              if i == 0 {
                  segmentedControl.selectedSegmentTintColor = UIColor.green
              } else if i == 1 {
                  segmentedControl.selectedSegmentTintColor = UIColor.brown
              } else if i == 2 {
                  segmentedControl.selectedSegmentTintColor = UIColor.orange
              }
      }
      
    @IBAction func segmentedControlValueChange(_ sender: UISegmentedControl) {
        changeValue(sender: sender)
    }
}
