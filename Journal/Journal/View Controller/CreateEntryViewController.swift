//
//  ViewController.swift
//  Journal
//
//  Created by Norlan Tibanear on 8/9/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // Outlets
    @IBOutlet var createTitleTextField: UITextField!
    @IBOutlet var createEntryTextView: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTitleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    // MARK: - Actions
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let title = createTitleTextField.text, !title.isEmpty else { return }
        guard let entryLabel = createTitleTextField.text, !entryLabel.isEmpty else { return }
        
        Entry(title: title, bodyText: entryLabel)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
    }//
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    

} // Class

