//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Morgan Smith on 4/25/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    
    @IBOutlet weak var journalMood: UISegmentedControl!
      
      @IBOutlet weak var journalTitle: UITextField!
      
      @IBOutlet weak var journalText: UITextView!
    
    var entry: Entry?
    var wasEdited: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
navigationItem.rightBarButtonItem = editButtonItem

        updateViews()
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        
        journalMood.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: EntryMood(rawValue: entry.mood!)!) ?? 1
        
        journalTitle.text = entry.title
        journalText.text = entry.bodyText
        
        journalTitle.isUserInteractionEnabled = isEditing
        journalMood.isUserInteractionEnabled = isEditing
        journalText.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if editing == true {
            wasEdited = true
        }
        journalTitle.isUserInteractionEnabled = editing
        journalMood.isUserInteractionEnabled = editing
        journalText.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited == true {
            let selectedMood = journalMood.selectedSegmentIndex
            entry!.mood = EntryMood.allCases[selectedMood].rawValue
            entry?.bodyText = journalText.text
            entry?.title = journalTitle.text
        }
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving manage object contedxt: \(error)")
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
