//
//  EntryDetailsViewController.swift
//  Journal
//
//  Created by Jason Modisett on 9/17/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import UIKit

class EntryDetailsViewController: UIViewController {

    // MARK:- View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let entry = entry else {
            
            title = "New entry"
            
            return
        }
        
        title = entry.title
        
        entryTitleTextField.text = entry.title
        entryContentTextView.text = entry.bodyText
        
        var mood: Mood?
        
        if let moodValue = entry.mood {
            mood = Mood(rawValue: moodValue)
        } else { mood = .🤓 }
        
        guard let moodIndex = Mood.allMoods.index(of: mood ?? .🤓) else { return }
        segmentedControl.selectedSegmentIndex = moodIndex
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let entryController = entryController,
              let titleText = entryTitleTextField.text,
            let bodyText = entryContentTextView.text else { return }
        
        let moodIndex = segmentedControl.selectedSegmentIndex
        let mood = Mood.allMoods[moodIndex]
        
        guard let entry = entry else {
            entryController.createEntry(with: titleText, bodyText: bodyText, mood: mood)
            navigationController?.popViewController(animated: true)
            return
        }
        
        entryController.update(entry: entry, with: titleText, bodyText: bodyText, mood: mood)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Properties & types
    var entry: Entry?
    var entryController: EntryController?
    
    // MARK:- IBOutlets
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryContentTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
}
