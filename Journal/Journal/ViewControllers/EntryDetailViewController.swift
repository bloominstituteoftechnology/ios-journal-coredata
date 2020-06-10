//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Clayton Watkins on 6/5/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var emotionSegmentedController: UISegmentedControl!
    @IBOutlet weak var entryTextView: UITextView!
    
    
    //MARK: - Properties
    var entry: Entry?
    var wasEdited: Bool = false
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            wasEdited = true
        }
        entryTitleTextField.isUserInteractionEnabled = editing
        emotionSegmentedController.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited{
            guard let title = entryTitleTextField.text, !title.isEmpty,
                let entryText = entryTextView.text, !entryText.isEmpty,
                let entry = entry
                else { return }
            let moodIndex = emotionSegmentedController.selectedSegmentIndex

            entry.title = title
            entry.bodyText = entryText
            entry.mood = Mood.allCases[moodIndex].rawValue

            do{
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    //MARK: - Private Functions
    private func updateViews(){
        entryTitleTextField.text = entry?.title
        entryTitleTextField.isUserInteractionEnabled = isEditing
        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else{
            mood = .😐
        }
        
        emotionSegmentedController.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        emotionSegmentedController.isUserInteractionEnabled = isEditing
    }
}
