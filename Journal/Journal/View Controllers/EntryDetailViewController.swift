//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Eoin Lavery on 10/08/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    
    //MARK: - PROPERTIES
    var entry: Entry?
    var wasEdited = false
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true {
            wasEdited = true
        }
        
        titleTextField.isUserInteractionEnabled = editing
        detailsTextView.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited == true {
            guard let title = titleTextField.text, !title.isEmpty,
                let body = detailsTextView.text else { return }
            
            var mood: Mood?
            
            switch moodSegmentedControl.selectedSegmentIndex {
            case 0:
                mood = .happy
            case 1:
                mood = .neutral
            case 2:
                mood = .sad
            default:
                mood = .neutral
            }
            
            entry?.title = title
            entry?.bodyText = body
            entry?.mood = mood?.rawValue
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error updating Journal Entry on mainContext.")
            }
        }
    }
    
    //MARK: - PRIVATE FUNCTIONS
    private func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        detailsTextView.text = entry.bodyText
        
        switch entry.mood {
        case "😀":
            moodSegmentedControl.selectedSegmentIndex = 0
        case "😐":
            moodSegmentedControl.selectedSegmentIndex = 1
        case "😞":
            moodSegmentedControl.selectedSegmentIndex = 2
        default:
            moodSegmentedControl.selectedSegmentIndex = 1
        }
        
        titleTextField.isUserInteractionEnabled = isEditing
        detailsTextView.isUserInteractionEnabled = isEditing
        moodSegmentedControl.isUserInteractionEnabled = isEditing
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
