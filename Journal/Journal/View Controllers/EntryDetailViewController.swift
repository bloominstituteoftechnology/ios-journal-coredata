//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    
    var entry: Entry?
    var entryController: EntryController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
    }
}
