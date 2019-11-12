//
//  EntryDetailViewController.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text else { return }
        guard let description = descriptionTextView.text else { return }
        
        if let entry = entry {
            entryController?.update(entry, title: title, bodyText: description, timeStamp: Date())
        } else {
            entryController?.create(title: title, bodyText: description, timeStamp: Date())
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateViews() {
        guard isViewLoaded else { return }
        
            title = entry?.title ?? "Create Entry"
            titleTextField.text = entry?.title
            descriptionTextView.text = entry?.description
            
        
        
    }
    
    
    
}
