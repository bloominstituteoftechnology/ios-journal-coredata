//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Clayton Watkins on 6/3/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var emotionSegementedController: UISegmentedControl!
    
    //MARK: - Properties
    var entryController: EntryController?
    
    //MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryTitle = entryTitleTextField.text, !entryTitle.isEmpty,
            let entryTextView = entryTextView.text, !entryTextView.isEmpty else { return }
        let currentTime = Date()
        
        // As of day 2 I had been using a random Int for my identifier
        // However, I feel that is in my best interest to instead use a UUID
        
        //        func getRandomIdentifier(in range: ClosedRange<Int>) -> Int{
        //            let myIdentifier = Int.random(in: range)
        //            return myIdentifier
        //        }
        //        let randomIdentifier = getRandomIdentifier(in: 1...100_000)
        
        let moodIndex = emotionSegementedController.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]

        let entry = Entry(timestamp: currentTime, title: entryTitle, bodyText: entryTextView, mood: mood)
        entryController?.sendEntryToServer(entry: entry)
        do{
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
