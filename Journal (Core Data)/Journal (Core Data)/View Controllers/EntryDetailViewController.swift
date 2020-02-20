//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

// MARK: - Mood enum

enum Mood: String {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "🙂"
    
    static var allMoods: [Mood] {
        return [.sad, .neutral, .happy]
    }
    
    static var allRawValues: [String] {
        return allMoods.map { $0.rawValue }
    }
}

// MARK: - Class Definition

class EntryDetailViewController: UIViewController {

    // MARK: - Properties

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController!
    
    // MARK: - IBOutlets

    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        guard let bodyText = bodyTextView.text,
            !bodyText.isEmpty else { return }
        
        let mood = Mood.allMoods[moodSegmentedControl.selectedSegmentIndex].rawValue
        
        CoreDataStack.shared.mainContext.perform {
            if let entry = self.entry {
                self.entryController.updateEntry(entry,
                                            updatedTitle: title,
                                            updatedBodyText: bodyText,
                                            updatedMood: mood)
            } else {
                self.entryController.createEntry(withTitle: title, bodyText: bodyText, mood: mood)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UpdateViews
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        CoreDataStack.shared.mainContext.perform {
            if let entry = self.entry {
                self.title = entry.title
                self.titleTextField.text = entry.title
                self.bodyTextView.text = entry.bodyText
                if let moodString = entry.mood,
                    let moodIndex = Mood.allRawValues.firstIndex(of: moodString) {
                    self.moodSegmentedControl.selectedSegmentIndex = moodIndex
                } else {
                    self.moodSegmentedControl.selectedSegmentIndex = 1
                }
            } else {
                self.title = self.entry?.title ?? "Create Entry"
            }
        }
    }
}
