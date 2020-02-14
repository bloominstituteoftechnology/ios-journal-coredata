//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

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
    
    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        guard let bodyText = bodyTextView.text,
            !bodyText.isEmpty else { return }
        
        let mood = Mood.allMoods[moodSegmentedControl.selectedSegmentIndex].rawValue
        
        if let entry = entry {
            entryController.updateEntry(entry,
                                        updatedTitle: title,
                                        updatedBodyText: bodyText,
                                        updatedMood: mood)
        } else {
            entryController.createEntry(withTitle: title, bodyText: bodyText, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        if let entry = entry {
            title = entry.title
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            if let moodString = entry.mood,
                let moodIndex = Mood.allRawValues.firstIndex(of: moodString) {
                moodSegmentedControl.selectedSegmentIndex = moodIndex
            } else {
                moodSegmentedControl.selectedSegmentIndex = 1
            }
        } else {
            title = entry?.title ?? "Create Entry"
        }
        
        
    }
}
