//
//  ViewController.swift
//  Journal
//
//  Created by Mark Poggi on 4/20/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - Properties
    
//    static let identifier: String = String(describing: CreateEntryViewController.self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem){
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func save(_ sender: UIBarButtonItem){
        
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
        guard let bodyText = entryTextView.text, !bodyText.isEmpty else { return }
        
        let timestamp = Date()

        Entry(title: title, bodyText: bodyText, timestamp: timestamp)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

