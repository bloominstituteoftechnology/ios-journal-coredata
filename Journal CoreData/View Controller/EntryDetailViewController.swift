//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Andrew Ruiz on 9/16/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let unwrappedTitleText = titleTextField.text,
            let unwrappedBodyText = bodyTextView.text,
            !unwrappedTitleText.isEmpty,
            !unwrappedBodyText.isEmpty else { return }
        
        let index = prioritySegmentedControl.selectedSegmentIndex
        let emojiSelected = EmojiSelection.allCases[index]
        
        if let unwrappedEntry = entry {
            entryController?.updateEntry(entry: unwrappedEntry, with: unwrappedTitleText, bodyText: unwrappedBodyText, timestamp: Date(), mood: emojiSelected.rawValue)
        } else {
            entryController?.createEntry(with: unwrappedTitleText, bodyText: unwrappedBodyText, timestamp: Date(), mood: emojiSelected.rawValue)
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateViews() {
        
        guard let entry = entry, isViewLoaded else { return }
        title = entry.title
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
        
    }

}
