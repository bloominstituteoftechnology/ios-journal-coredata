//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/28/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    //MARK: - IBOutlets and properties -
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var moodSegmentedControl: UISegmentedControl!
    @IBOutlet var notesTextView: UITextView!
    
    var entry: Entry?
    var wasEdited: Bool = false
    
    //MARK: - Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        
        titleTextField.text = entry.title
        notesTextView.text = entry.bodyText
        moodSegmentedControl.selectedSegmentIndex = 1
        
        titleTextField.isUserInteractionEnabled = isEditing
        moodSegmentedControl.isUserInteractionEnabled = isEditing
        notesTextView.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            wasEdited = true
        }
        
        titleTextField.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        notesTextView.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            
            guard let title = titleTextField.text,
                let notes = notesTextView.text,
                !title.isEmpty,
                !notes.isEmpty else { return }
            
            
            
        }
        
    }

}
