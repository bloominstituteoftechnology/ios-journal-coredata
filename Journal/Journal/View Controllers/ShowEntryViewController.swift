//
//  ShowEntryViewController.swift
//  Journal
//
//  Created by Cameron Collins on 4/22/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class ShowEntryViewController: UIViewController {

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let entry = entry else {
            return
        }
        
        entry.title = textFieldTitle.text
        entry.bodyText = textViewDescription.text
        
        var mood: MoodType?
               
        switch segmentedControlMood.selectedSegmentIndex {
        case 0:
            mood = MoodType.happy
        case 1:
            mood = MoodType.moderate
        case 2:
            mood = MoodType.unhappy
        default:
            mood = MoodType.moderate
        }
        
        guard let newMood = mood?.rawValue else {
            return
        }
        
        entry.mood = newMood
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    //MARK: - Variables
    var entry: Entry?
    var canEdit = false
    
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        canEdit = !canEdit
        
        if canEdit == true {
            sender.title = "Done"
            cancelButton.isEnabled = false
        } else {
            cancelButton.isEnabled = true
            sender.title = "Edit"
            
            //Save Content
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("Couldn't Save: \(error)")
            }
        }
         
        textFieldTitle.isUserInteractionEnabled = canEdit
        textViewDescription.isUserInteractionEnabled = canEdit
        segmentedControlMood.isUserInteractionEnabled = canEdit
    }
    
    //MARK: - Outlet
    @IBOutlet weak var segmentedControlMood: UISegmentedControl!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //MARK: - Functions
    //Updates Views
    func updateView() {
        textFieldTitle.text = entry?.title
        textViewDescription.text = entry?.bodyText
        textFieldTitle.isUserInteractionEnabled = canEdit
        textViewDescription.isUserInteractionEnabled = canEdit
        segmentedControlMood.isUserInteractionEnabled = canEdit
        
        var mood: Int = 0
        
        switch entry?.mood {
        case MoodType.happy.rawValue:
            mood = 0
        case MoodType.moderate.rawValue:
            mood = 1
        case MoodType.unhappy.rawValue:
            mood = 2
        default:
            mood = 1
        }
        
        segmentedControlMood.selectedSegmentIndex = mood
    }
}

