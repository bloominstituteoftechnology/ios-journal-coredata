//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Breena Greek on 4/24/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    var entry: Entry?
    var wasEdited: Bool = false
    var taskController: TaskController?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var bodyTextField: UITextView!
    
    // MARK: - IBActions
    @IBAction func moodControlChanged(_ sender: UIButton) {
        wasEdited = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         if wasEdited {
             guard let title = titleTextField.text,
                 !title.isEmpty,
                 let entry = entry else {
                 return
             }
             let body = bodyTextField.text
             entry.title = title
             entry.bodyText = body
             let priorityIndex = moodControl.selectedSegmentIndex
             entry.mood = Mood.allCases[priorityIndex].rawValue
            taskController?.sendEntryToServer(entry: entry, completion: { _ in })
             do {
                 try CoreDataStack.shared.mainContext.save()
             } catch {
                 NSLog("Error saving managed object context: \(error)")
             }
         }
     }
    
    
    func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let chosenMood = entry?.mood {
          mood = Mood(rawValue: chosenMood)!
        } else {
            mood = .neutral
        }
        moodControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodControl.isUserInteractionEnabled = isEditing
        
        bodyTextField.text = entry?.bodyText
        bodyTextField.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
         if editing { wasEdited = true }
              
              titleTextField.isUserInteractionEnabled = editing
              bodyTextField.isUserInteractionEnabled = editing
              moodControl.isUserInteractionEnabled = editing
              navigationItem.hidesBackButton = editing
    }
    
    @objc func save() {
            guard let title = titleTextField.text,
                !title.isEmpty else { return }

            guard let body = bodyTextField.text,
                !body.isEmpty else { return }

            let selctedPriority = moodControl.selectedSegmentIndex
            let mood = Mood.allCases[selctedPriority]

            Entry(title: title,
                  bodyText: body,
                  mood: mood.rawValue,
                  context: CoreDataStack.shared.mainContext)

            do {
                try CoreDataStack.shared.mainContext.save()
                navigationController?.dismiss(animated: true, completion: nil)
            } catch {
                NSLog("Error saving manage object context: \(error)")
        }
    }
}
