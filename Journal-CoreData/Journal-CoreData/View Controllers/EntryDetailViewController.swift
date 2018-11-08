//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Jerrick Warren on 11/6/18.
//  Copyright © 2018 Jerrick Warren. All rights reserved.
//

import UIKit
import CoreData


class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews(){
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        entryTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
    }
    
    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    
    // MARK: - Properties

    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = entryTextField.text,
            
        let text = entryTextView.text, !text.isEmpty else {return}
        
        print(title)
        print(text)
        
        if let entry = entry {
            entryController.updateEntry(entry: entry, title: title, bodyText: text)
        } else {
            entryController.createEntry(title: title, bodyText: text)
        }
        navigationController?.popViewController(animated: true)
//
//        entryController?.saveToPersistentStore()
//        entryController?.createEntry(title: entryTextField?.text ?? "Testing", bodyText: entryTextView?.text ?? "TextFieldTestin" )
        
    }
    
    
    // ? means "I don't need this to exist for my program to be correct"
    // ! means "This needs to exist for my program to be correct but
    //          I can't initialize my class with it"
    var entryController: EntryController!
}

