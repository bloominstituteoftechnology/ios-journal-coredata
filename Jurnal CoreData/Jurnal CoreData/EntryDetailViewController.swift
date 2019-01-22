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
        guard isViewLoaded == true else { return }
            
        if let data = entry {
        textField.text = data.title
        textView.text = data.bodyText
        title = data.title
        } else {
            title = "Create Entry"
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBAction func saveButton(_ sender: Any) {
        
      //  let title = textField.text
        guard let title = textField.text, let body = textView.text else {
            return
        }
        
        if let entry = entry {
            
            
           entryController?.update(entry: entry, title: title, bodyText: body)
            print(entry)
            
        } else  {
            
            entryController?.create(title: title, bodyText: body)
        }
            navigationController?.popViewController(animated: true)
    }
}
