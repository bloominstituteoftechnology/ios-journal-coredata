//
//  ViewController.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    //MARK: Properties
    var journalEntry: Entry?
    var entryController: EntryController?

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = journalEntry?.title ?? "New Entry"
        titleTextField.text = journalEntry?.title ?? ""
        bodyTextView.text = journalEntry?.bodyText ?? ""
        if journalEntry == nil {
            //save Button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntry))
            //cancel Button
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updateEntry))
        }
    }
    
    @objc func dismissView() {
        if journalEntry == nil {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: Create/Save
    @objc func saveEntry() {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = bodyTextView.text,
            !bodyText.isEmpty
        else {return}
//        journalEntry?.title = title
//        journalEntry?.bodyText = bodyText
//        journalEntry?.timestamp = Date()
//        journalEntry?.identifier = UUID()
        entryController?.createEntry(title: title, bodyText: bodyText)
        dismissView()
    }
    
    @objc func updateEntry() {
        guard let entry = journalEntry,
            let newTitle = titleTextField.text,
            !newTitle.isEmpty,
            let newBodyText = bodyTextView.text,
            !newBodyText.isEmpty
        else {return}
        entryController?.updateEntry(newTitle: newTitle, newBodyText: newBodyText, entry: entry)
        dismissView()
    }
    
    


}

