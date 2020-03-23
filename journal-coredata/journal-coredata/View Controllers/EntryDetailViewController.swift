//
//  EntryDetailViewController.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var entry: Entry?
    var entryController: EntryController?
    
    // MARK: -  Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // MARK: - Button Action
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
    }

}

