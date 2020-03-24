//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entryController: EntryController?
    var entry: Entry?
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func save(_ sender: Any) {
        
        guard let title = textField.text,
            !title.isEmpty,
            let desc = textView.text,
            !desc.isEmpty
            else {
                return
        }
        
        entryController?.create(title: title, bodyText: desc)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

