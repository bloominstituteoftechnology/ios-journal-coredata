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
    
    
    @IBOutlet weak var journalTitle: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeValue(sender: segmentedControl)
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = journalTitle.text,
                       let body = entryTextView.text,
                       !title.isEmpty,
                       !body.isEmpty else { return }
            
                   let selectedMood = segmentedControl.selectedSegmentIndex
                   
                   let mood = Mood.allCases[selectedMood]
                   
                   Entry(title: title,
                         bodyText: body,
                         mood: mood)
                   
                   do {
                       try CoreDataStack.shared.mainContext.save()
                       navigationController?.dismiss(animated: true)
                   } catch {
                       NSLog("Error saving managed object context: \(error)")
                   }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing {
            wasEdited = true
            journalTitle.isUserInteractionEnabled = editing
            entryTextView.isUserInteractionEnabled = editing
            segmentedControl.isUserInteractionEnabled = editing
            navigationItem.hidesBackButton = editing
        }
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        var which: Int = 0
        journalTitle.text = entry.title
        entryTextView.text = entry.bodyText
        segmentedControl.isUserInteractionEnabled = isEditing
        switch entry.mood {
        case "😀":
            which = 0
             segmentedControl.selectedSegmentTintColor = UIColor.green
        case "😫":
            which = 1
            segmentedControl.selectedSegmentTintColor = UIColor.brown
        case "😐":
            which = 2
            segmentedControl.selectedSegmentTintColor = UIColor.orange
        default:
            break
        }
        segmentedControl.selectedSegmentIndex = which
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
      
    @IBAction func sControl(_ sender: UISegmentedControl) {
        changeValue(sender: sender)
    }
}
