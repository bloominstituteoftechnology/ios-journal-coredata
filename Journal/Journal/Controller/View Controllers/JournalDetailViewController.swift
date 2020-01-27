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
        #warning("implement identifier")
        let _ = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: "")
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Saving Task failed with error: \(error)")
        }
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = journalEntry?.title ?? "New Entry"
        titleTextField.text = journalEntry?.title ?? ""
        bodyTextView.text = journalEntry?.bodyText ?? ""
    }


}

