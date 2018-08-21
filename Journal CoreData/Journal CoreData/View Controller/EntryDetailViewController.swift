//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func Save(_ sender: Any) {
        guard let name = nameTextField.text, let bodyText = bodytextView.text else { return }
        if let entry = entry {
            entryController?.updateEntry(entry: entry, name: name, bodyText: bodyText)
        } else {
            entryController?.createEntry(name: name, bodyText: bodyText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodytextView: UITextView!
    
    var entry: Entry?
    var entryController: EntryController?
    

}
