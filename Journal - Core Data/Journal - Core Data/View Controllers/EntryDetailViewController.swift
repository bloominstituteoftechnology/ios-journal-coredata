//
//  EntryDetailViewController.swift
//  Journal - Core Data
//
//  Created by Lisa Sampson on 8/20/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func saveButtonWasTapped(_ sender: Any) {
        
    }
    
    var entry: Entry?
    var entryController: EntryController?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
}
