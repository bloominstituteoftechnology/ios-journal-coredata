//
//  EntryDetailViewController.swift
//  Core Data Journal
//
//  Created by Jaspal on 2/18/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    
    @IBAction func save(_ sender: Any) {
        
        let title = titleTextField!.text

        let bodyText = entryTextView!.text
        
        if let entry = entry {
            entryController?.update(title: title!, bodyText: bodyText!, entry: entry)
        } else {
            entryController?.create(title: title!, bodyText: bodyText!)
        }
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var entryTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?

    func updateViews() {
        guard isViewLoaded else { return }
        
        if entry?.title == nil {
            navigationItem.title = "Create Entry"
        } else {
            navigationItem.title = entry?.title
        }
        
        titleTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
        
    }

}
