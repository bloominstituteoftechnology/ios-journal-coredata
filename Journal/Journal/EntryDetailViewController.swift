//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Lydia Zhang on 3/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textBody: UITextView!
    
    var entry: Entry? {
        didSet {
            updateView()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Do any additional setup after loading the view.
    }
    
    func updateView() {
        guard textField.text != nil else {return}
        if let entry = entry {
            title = entry.title
            textField.text = entry.title
            textBody.text = entry.bodyText
        } else {
            title = "Create a New Journal"
            textField.text = " "
            textBody.text = " "
            
        }
    }
    @IBAction func save(_ sender: Any) {
        guard let title = textField.text,
            let body = textBody.text,
            !title.isEmpty, !body.isEmpty else {
                return
        }
        
        if let entry = entry, let entryController = entryController {
            entryController.update(entry: entry, title: title, bodyText: body)
        } else if let entryController = entryController {
            entryController.create(title: title, bodyText: body)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    

}
