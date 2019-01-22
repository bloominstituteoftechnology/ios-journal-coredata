//
//  EntryDetailViewController.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            
        if let data = entry {
        textField.text = data.title
        textView.text = data.bodyText
        title = data.title
        } else {
            title = "Create Entry"
        }
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBAction func saveButton(_ sender: Any) {
        
      //  let title = textField.text
        guard let title = textField.text, title.isEmpty == false else {
            return
        }
        guard let body = textView.text, body.isEmpty == false else {
            return
        }
        
        if let curentEntry = entry {
            
            entryController?.update(entry: curentEntry, title: title, bodyText: body)
            
        } else  {
            
            entryController?.create(title: title, bodyText: body)
        }
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save \(error)")
        }
    }
    }
