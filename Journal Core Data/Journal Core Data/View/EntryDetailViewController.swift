//
//  EntryDetailViewController.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - UI Methods
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = bodyTextView.text, !bodyText.isEmpty,
        let mood = moodSegmentedControl.titleForSegment(at: moodSegmentedControl.selectedSegmentIndex) else { return }
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Utility Methods
    private func updateViews() {
        guard isViewLoaded else { return }
        guard let entry = entry else {
            moodSegmentedControl.selectedSegmentIndex = 1
            title = "Add Entry"
            return
        }
        
        title = entry.title
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
        
        moodSegmentedControl.selectedSegmentIndex = segmentIndexToSelect(entry)
    }
    
    /// Closure that takes an entry and returns the index that should be selected on the Segmented Control
    let segmentIndexToSelect: (Entry) -> Int = { entry in
        switch entry.mood {
        case "😔": return 0
        case "🙂": return 2
        default: return 1
        }
    }
}
