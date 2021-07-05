//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Andrew Ruiz on 10/14/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalEntryTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        journalEntryTextView.text = entry?.bodyText
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if let journalEntry = journalEntryTextView.text,
            let title = titleTextField.text {
            
            if let entry = entry {
                entryController?.updateEntry(entry: entry, with: title, bodyText: journalEntry, identifier: "123", timestamp: Date())
            } else {
                entryController?.createEntry(with: title, bodyText: journalEntry, identifier: "123", timestamp: Date(), context: CoreDataStack.shared.mainContext)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}
