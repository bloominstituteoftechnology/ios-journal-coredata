//
//  EntryDetailViewController.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let titleText = titleTextField.text,
              let bodyText = textView.text else {return}
        
        if (entry != nil) {
            guard let entry = entry else {return print("Theres no entry")}
            entryController?.update(entry: entry, title: titleText, bodyText: bodyText)
            self.navigationController?.popViewController(animated: true)
        } else {
            entryController?.create(title: titleText, bodyText: bodyText)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//Functions
extension EntryDetailViewController {
    
    func updateViews() {
        guard isViewLoaded else {return print("View Didn't Load")}
        if entry == nil {
            self.title = "Create Entry"
        } else {
            self.title = entry?.title
            titleTextField.text = entry?.title
            textView.text = entry?.bodyText
        }
    }
}
