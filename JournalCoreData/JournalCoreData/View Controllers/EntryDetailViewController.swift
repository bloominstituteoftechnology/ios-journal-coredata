//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by John Holowesko on 2/13/20.
//  Copyright © 2020 John Holowesko. All rights reserved.
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
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = textField.text,
            !title.isEmpty else { return }
        
       let bodyText = textView.text
        
        guard let entry = entry else {
            entryController?.create(title: title, bodyText: bodyText)
            navigationController?.popViewController(animated: true)
            return
        }
        entryController?.update(title: title, bodyText: bodyText, entry: entry)
        
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Functions
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        
        textField.text = entry?.title
        textView.text = entry?.bodyText
    }
}
