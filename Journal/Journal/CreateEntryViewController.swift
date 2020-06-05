//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Josh Kocsis on 6/3/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit
import CoreData

class CreateEntryViewController: UIViewController {
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var articleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTitleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text,
            !title.isEmpty, let bodyText = articleTextView.text,
            !bodyText.isEmpty else { return }
               
                
               Entry(title: title, bodyText: bodyText)
               
               do {
                   try CoreDataStack.shared.mainContext.save()
                   navigationController?.dismiss(animated: true, completion: nil)
               } catch {
                   NSLog("Error saving managed object context: \(error)")
               }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

