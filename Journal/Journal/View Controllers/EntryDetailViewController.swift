//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/10/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var entryController: EntryController?
    
    var entries: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let titleEntry = titleTextField.text,
            let detailEntry = detailView.text else {return}
        if let entry = entries {
            entryController?.update(entry: entry, title: titleEntry, bodyText: detailEntry)
        } else {
            entryController?.createEntry(title: titleEntry, bodyText: detailEntry)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews(){
        guard isViewLoaded else {return}
        self.navigationItem.title = entries?.title ?? "Entry"
        titleTextField.text = entries?.title
        detailView.text = entries?.bodyText
    }

}
