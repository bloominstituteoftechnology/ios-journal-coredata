//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by brian vilchez on 10/15/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //MARK: - properties
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextVIew: UITextView!
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?

    override func viewDidLoad() {
        super.viewDidLoad()
        entryBodyTextVIew.text = ""
        entryBodyTextVIew.backgroundColor = #colorLiteral(red: 0.9568627451, green: 1, blue: 0.9490196078, alpha: 1)
        updateViews()
    }
    
    private func updateViews() {
        if entry == nil {
             title = "Create an entry"
        } else {
           title = entry?.title
        }
        guard let entry = entry else {return}
        entryBodyTextVIew.text = entry.bodyText
        entryTitleTextField.text = entry.title
    }
    
    //MARK: - Actions
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text, let bodyText = entryBodyTextVIew.text
            else {return}
        
        if let entry = entry  {
            entryController?.updateEntry(ForEntry: entry, with: title, bodyText: bodyText)
        } else {
            entryController?.createEntry(withTitle: title, bodyText: bodyText, context: CoreDataStack.shared.context)
        }
        navigationController?.popViewController(animated: true)
    }
    
  

}
