//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by Sammy Alvarado on 8/9/20.
//  Copyright © 2020 Sammy Alvarado. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry?
    var wasEdited = false

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var entryTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if wasEdited {
            guard let title = titleTextField.text,
                !title.isEmpty,
                let entry = entry else { return }
            let journalEntry = entryTextView.text
            entry.title = title
            entry.bodyText = journalEntry
            let moodIndex = moodSegmentedControl.selectedSegmentIndex
            entry.mood = Mood.allCases[moodIndex].rawValue

            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("error Saving manged objected Context")
            }
        }
    }

    /*
     Override the viewWillDisappear(_:) method
     Call the superclass implementation
     Check if wasEdited is true. If so, collect entry data from the user interface controls and update the entry managed object
     Call save on the main context from your CoreDataStack singleton
     */

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if editing { wasEdited = true }

        titleTextField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }


    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing

        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing

        let mood: Mood
        if let selectableMood = entry?.mood {
            mood = Mood(rawValue: selectableMood)!
        } else {
            mood = .😐
        }
        moodSegmentedControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
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

