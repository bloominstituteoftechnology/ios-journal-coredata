//
//  EntryDetailViewController.swift
//  JournalWithCoreData
//
//  Created by Carolyn Lea on 8/13/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController
{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextTextView: UITextView!
    
    var entry: Entry?
    {
        didSet
        {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateViews()
    }

    @IBAction func save(_ sender: Any)
    {
        guard let title = titleTextField.text,
            let bodyText = bodyTextTextView.text else {return}
        let newTime = Date()
        if let entry = entry 
        {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, timestamp: newTime as NSDate)
            print(titleTextField.text!, bodyTextTextView.text)
        }
        else
        {
            entryController?.createEntry(title: title, bodyText: bodyText)
            print(titleTextField.text!, bodyTextTextView.text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews()
    {
        guard isViewLoaded else {return}
        
        guard let entry = entry else {
            title = "Create Entry"
            return
        }
        title = entry.title
        titleTextField.text = entry.title
        bodyTextTextView.text = entry.bodyText
        
    }
    

}
