//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Josh Kocsis on 6/3/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var articleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTitleTextField.becomeFirstResponder()
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text,
            !title.isEmpty else { return }
               
               let bodyText = articleTextView.text
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

