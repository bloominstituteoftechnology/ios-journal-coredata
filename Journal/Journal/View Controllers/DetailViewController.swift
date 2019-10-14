//
//  DetailViewController.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
        
    
    // MARK: - Outlets
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryText: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let title = entryTitle.text,
            let bodyText = entryText.text {
            
            if let entry = entry {
                entryController?.updateEntry(entry: entry, with: title, bodyText: bodyText)
            } else {
                entryController?.createEntry(with: title, bodyText: bodyText, context: CoreDataStack.shared.mainContext)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        entryTitle.text = entry?.title
        entryText.text = entry?.bodyText
    }
}
