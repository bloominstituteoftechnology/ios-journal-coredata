//
//  ViewController.swift
//  CoreJournal
//
//  Created by Aaron Cleveland on 1/27/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var entry: Entry?
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let title = textField.text,
            let body = textView.text,
            !title.isEmpty else { return }
        if let entry = entry {
            entryController?.update(title: title, bodyText: body, entry: entry)
        } else {
            entryController?.createEntry(title: title,
                                         bodyText: body,
                                         timestamp: Date(),
                                         identifier: "1")
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title ?? ""
        textView.text = entry?.bodyText ?? ""
    }
    

}

