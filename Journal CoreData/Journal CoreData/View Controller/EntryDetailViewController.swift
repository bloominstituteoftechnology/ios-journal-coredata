//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet { updateViews() }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func saveBarButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else { return }
        
        // Get the index of selected mood
        let index = moodControl.selectedSegmentIndex
        let mood = Mood.allMoods[index]
        
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, mood: mood)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Update views
    
    private func updateViews() {
        
        if isViewLoaded == true {
            titleTextField.text = entry?.title
            bodyTextView.text = entry?.bodyText
            
            switch entry?.mood {
            case "😔":
                return moodControl.selectedSegmentIndex = 0
            case "😐":
                return moodControl.selectedSegmentIndex = 1
            case "😁":
                return moodControl.selectedSegmentIndex = 2
            default:
                return moodControl.selectedSegmentIndex = 1
            }
        }
        
        title = entry?.title ?? "Create Entry"
    }
}
