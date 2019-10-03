//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Joel Groomer on 10/2/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: JournalEntry? { didSet { updateViews() } }
    var entryController: EntryController?
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtvBody: UITextView!
    
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
