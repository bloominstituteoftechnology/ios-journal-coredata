//
//  DetailVCViewController.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import UIKit


   class EntryDetailViewController: UIViewController {

        var entry: Entry? { didSet { updateViews() } }
        var entryController: EntryController?
        
        @IBOutlet weak var txtTitle: UITextField!
        @IBOutlet weak var txtvBody: UITextView!
        @IBOutlet weak var segmentedControl: UISegmentedControl!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            updateViews()
        }
        

        @IBAction func saveTapped(_ sender: Any) {
            guard let entryController = entryController,
                let title = txtTitle.text, !title.isEmpty,
                let body = txtvBody.text
            else { return }
            
            if let entry = entry {
                entryController.updateEntry(entry: entry, newTitle: title, newBody: body)
            } else {
                entryController.createEntry(title: title, body: body)
            }
            
            navigationController?.popViewController(animated: true)
        }
        
        func updateViews() {
            guard isViewLoaded else { return }
            title = entry?.title ?? "Create Journal Entry"
            txtTitle.text = entry?.title ?? ""
            txtvBody.text = entry?.bodyText ?? ""
        }

    }
