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
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    // MARK: -  Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViews()
    }

    
    // MARK: - Button Action
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Private Method
    
    private func updateViews() {
        if isViewLoaded {
            if let entry = entry {
                title = entry.title
                titleField.text = entry.title
                textView.text = entry.bodyText
            } else {
                title = "Create Entry"
            }
        }
    }

}

