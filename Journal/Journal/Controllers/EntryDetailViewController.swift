//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Brian Rouse on 5/19/20.
//  Copyright © 2020 Brian Rouse. All rights reserved.
//


import UIKit
import CoreData

class EntryDetailViewController: UIViewController {
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var moodSegmentControl: UISegmentedControl!
    @IBOutlet private weak var bodyTextView: UITextView!
    
    var entry: Entry?
    var entryController: EntryController?
    
    private var wasEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [editButtonItem]
        updateViews()
    }
    
    private func updateViews() {
        guard let entry = entry else { fatalError() }
        
        let moodString = entry.mood ?? ""
        let mood = Mood(rawValue: moodString) ?? Mood.😐
        let moodIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        
        titleTextField.text = entry.title
        moodSegmentControl.selectedSegmentIndex = moodIndex
        bodyTextView.text = entry.bodyText
        
        [titleTextField, moodSegmentControl, bodyTextView].forEach {
            $0?.isUserInteractionEnabled = isEditing
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            wasEdited = true
        }
        [titleTextField, moodSegmentControl, bodyTextView].forEach {
            $0?.isUserInteractionEnabled = editing
        }
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let entry = entry else { return }
        
        if wasEdited {
            guard let title = titleTextField.text, !title.isEmpty,
                let text = bodyTextView.text, !text.isEmpty else { return }
            entry.title = title
            entry.bodyText = text
            
            let mood = Mood.allCases[moodSegmentControl.selectedSegmentIndex]
            entry.mood = mood.rawValue

            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", entry.identifier ?? "")
            
            do {
                let matchingEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
                let existingEntry = matchingEntries[0]
                existingEntry.title = title
                existingEntry.mood = mood.rawValue
                existingEntry.bodyText = text
                
                entryController?.sendEntryToServer(entry: existingEntry)
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving: \(error)")
            }
        }
    }
}
