//
//  ViewController.swift
//  Journal
//
//  Created by Bronson Mullens on 6/3/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var journalTitleTextField: UITextField!
    @IBOutlet weak var journalBodyTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = journalTitleTextField.text, !journalBodyTextView.text.isEmpty else { return }
        
        let bodyText = journalBodyTextView.text ?? ""
        
        Entry( identifier: "",
               title: title,
               bodyText: bodyText,
               timestamp: Date())
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving moc: \(error)")
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
