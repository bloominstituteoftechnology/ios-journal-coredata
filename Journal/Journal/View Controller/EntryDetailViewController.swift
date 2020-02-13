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

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        navigationItem.title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        textView.text = entry?.bodyText
    }
    
    @IBAction func saveEntry(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        let bodyText = textView.text
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, newTitle: title, newbodyText: bodyText ?? "")
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText ?? "", timestamp: Date(), identifier: "")
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    

}
