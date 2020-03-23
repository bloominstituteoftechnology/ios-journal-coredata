//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var entry: Entry?
    var entryController: EntryController?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
        setBorder(for: titleTextField, bodyTextView)
       
        
    }
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Private
    
    private func setBorder(for views: UIView...) {
        views.forEach {
            $0.layer.borderColor = UIColor.systemGray3.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 6.0
        }
    }


}

