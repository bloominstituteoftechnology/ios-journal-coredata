//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/26/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    var entry: Entry?
    var wasEdited: Bool = false
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var entryTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    func updateViews() {
        
        guard let entry = entry else { return }
        
        titleTextField.text = entry.title
        entryTextView.text = entry.bodyText
        
        if entry.mood == "😄" {
            moodControl.selectedSegmentIndex = 0
        } else if entry.mood == "😔" {
            moodControl.selectedSegmentIndex = 1
        } else {
            moodControl.selectedSegmentIndex = 2
        }
            
        titleTextField.isUserInteractionEnabled = isEditing
        moodControl.isUserInteractionEnabled = isEditing
        entryTextView.isUserInteractionEnabled = false
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(true, animated: true)
        
        if editing == true {
            wasEdited = true
        } else {
            wasEdited = false
        }
        
        titleTextField.isUserInteractionEnabled = editing
        moodControl.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if wasEdited == true {
            updateViews()
        }
        
        try! CoreDataStack.shared.mainContext.save()
        
    }
}
