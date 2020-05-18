//
//  ViewController.swift
//  Journal
//
//  Created by Dahna on 5/18/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    // MARK: Actions
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        guard let bodyText = bodyTextView.text,
            !bodyText.isEmpty else { return }
        
        Entry(identifier: UUID().uuidString, title: title, bodyText: bodyText)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving entry: \(error)")
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

