//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Andrew Ruiz on 9/16/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let unwrappedTitleText = titleTextField.text,
            let unwrappedBodyText = bodyTextView.text,
            !unwrappedTitleText.isEmpty,
            !unwrappedBodyText.isEmpty else { return }
        
        if let unwrappedEntry = entry {
            entryController?.updateEntry(entry: unwrappedEntry, with: unwrappedTitleText, bodyText: unwrappedBodyText, identifier: "RandomIdentifier", timestamp: Date())
        } else {
            entryController?.createEntry(with: unwrappedTitleText, bodyText: unwrappedBodyText, identifier: "RandomIdentifier", timestamp: Date())
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateViews() {
        
        title = entry?.title ?? "Create Entry"
        
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        
    }

}
