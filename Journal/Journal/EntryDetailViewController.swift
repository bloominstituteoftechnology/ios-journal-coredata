//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!

    
    
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let entryController = entryController,
            let entryTitle = entryBodyTextView.text,
            let bodyText = entryBodyTextView.text
            else { return }
        
        if let entry = entry {
            entryController.update(entry: entry, title: entryTitle, bodyText: bodyText)
        } else {
            entryController.create(title: entryTitle, timeStamp: Date(), bodyText: bodyText, identifier: "")
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        entryTitleTextField.text = entry?.title
        entryBodyTextView.text = entry?.bodyText
    }

}
