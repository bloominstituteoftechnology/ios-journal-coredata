//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Daniela Parra on 9/17/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    private func updateViews() {
        if isViewLoaded {
            guard let entry = entry else {
                title = "Create Entry"
                return
            }
            
            title = entry.title
            
            nameTextField.text = entry.title
            bodyTextView.text = entry.bodyText
        }
    }
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = nameTextField.text,
            let bodyText = bodyTextView.text else { return }
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText)
        } else {
            entryController?.createEntry(with: title, bodyText: bodyText)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Properties
    
    var entryController: EntryController?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
}
