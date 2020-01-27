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
    
    
    var journalEntry: Entry?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @objc func saveTask() {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = bodyTextView.text,
            !bodyText.isEmpty
        else {return}
        journalEntry?.title = title
        journalEntry?.bodyText = bodyText
        journalEntry?.timestamp = Date()
        #warning("implement identifier")
        //context here
        let _ = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: "")
        //context -> coordinator -> persistent store here
        //entryController.saveToPersistentStore
        dismissView()
    }
    
    @objc func dismissView() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = journalEntry?.title ?? "New Entry"
        titleTextField.text = journalEntry?.title ?? ""
        bodyTextView.text = journalEntry?.bodyText ?? ""
        if journalEntry == nil {
            //save Button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
            //cancel Button
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        }
    }


}

