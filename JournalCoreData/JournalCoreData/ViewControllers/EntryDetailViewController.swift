//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by admin on 10/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Set Title"
        titleTextField.text = "title"
        entryTextView.text = "entry"
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        if let title = titleTextField.text,
            let body = entryTextView.text {
            
            if let entry = entry {
                entryController?.updateEntry(entry: entry, with: title, bodyText: body, timestamp: <#T##Date#>, identifier: <#T##String#>)
            } else {
                entryController?.createEntry(with: title, bodyText: body, timestamp: <#T##Date#>, identifier: <#T##String#>, context: CoreDataStack.shared.mainContext)
            }
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
