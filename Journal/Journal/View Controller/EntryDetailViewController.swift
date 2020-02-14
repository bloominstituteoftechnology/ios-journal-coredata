//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        titleTextField.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let entry = entry {
            title = entry.title
            titleTextField.text = entry.title
            textView.text = entry.bodyText
        } else {
            title = entry?.title ?? "Create Entry"
        }
    }
    
    @IBAction func saveEntry(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        guard let bodyText = textView.text,
            !bodyText.isEmpty else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry, newTitle: title, newbodyText: bodyText)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText)
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    

}
