//
//  ViewController.swift
//  Journal
//
//  Created by Nonye on 5/18/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    var timeStamp = NSDate.now
    
    var entryController: EntryController?
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var journalEntryTitleText: UITextField!
    
    @IBOutlet weak var journalTextView: UITextView!
    
    @IBOutlet weak var moodControl: UISegmentedControl!

    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - ACTIONS
    
    @IBAction func saveEntryTapped(_ sender: Any) {
        guard let title = journalEntryTitleText.text,
            !title.isEmpty,
            let bodyText = journalTextView.text,
            !bodyText.isEmpty else { return }
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        //MARK: - HELP
        let entry = Entry(identifier: identifier, title: title, bodyText: bodyText, timeStamp: timeStamp, context: _)
        entryController?.sendEntryToServer(entry: entry, completion: { _ in })
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context \(error)")
        }
    }
    
    @IBAction func cancelEntryTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

