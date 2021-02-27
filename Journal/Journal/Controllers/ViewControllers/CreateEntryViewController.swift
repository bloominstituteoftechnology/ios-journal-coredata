//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by James McDougall on 2/26/21.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = entryTextField.text,
              !title.isEmpty else { return }
        
        Entry(title: title)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving entry: \(error)")
        }
    }
    
}
