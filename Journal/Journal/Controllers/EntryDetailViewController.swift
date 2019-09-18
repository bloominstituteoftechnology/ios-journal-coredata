//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by brian vilchez on 9/16/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var entryController: EntryController?
    var entry: Entry? 

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else {return}
        guard let entry = entry else {
            title = "Create Entry"
            return
        }
        nameTextfield.text = entry.title
            descriptionTextView.text = entry.bodyText
      
    }

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        guard let title = nameTextfield.text, !title.isEmpty, let description = descriptionTextView.text,
            !description.isEmpty else {return}
        
        if let entry = entry {
            entryController?.updateEntry(with: entry, with: title, bodytext: description, identifier: "", timeStamp: Date())
            navigationController?.popViewController(animated: true)
        } else {
            entryController?.createEntry(with: title, bodytext: description, identifier: "", timeStamp: Date())
            navigationController?.popViewController(animated: true)
        }
    }

}
