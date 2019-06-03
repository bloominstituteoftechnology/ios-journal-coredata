//
//  EntryDetailViewController.swift
//  Journal - Day One
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Prepare to create or update a new journal entry
        updateViews()
    }
    
    // MARK: - Private Functions
    private func updateViews() {
        
    }
    
    // MARK: - Save Button
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Properties
    var entryController: EntryController?
    var entry: Entry? { didSet {updateViews()} }
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
}
