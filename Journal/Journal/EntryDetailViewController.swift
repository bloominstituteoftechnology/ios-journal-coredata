//
//  ViewController.swift
//  Journal
//
//  Created by Rick Wolter on 11/11/19.
//  Copyright © 2019 Richar Wolter. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

 
    var entry: Entry? {
        didSet{
            updateViews()        }
    }
    
    @IBOutlet private weak var entryTitleTextField: UITextField!
    @IBOutlet private weak var entryBodyTextView: UITextView!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           updateViews()
       }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryTitle = entryTitleTextField.text, !entryTitle.isEmpty else {return}
        let entryBody = entryBodyTextView.text
        
        if let entry = entry {
            entry.title = entryTitle
            entry.bodyText = entryBody
        } else {
            let _ = Entry(title: entryTitle, bodyText: entryBody, timestamp: Date.init(), indentifier: nil)
        }
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context \(error)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews(){
        guard isViewLoaded else {return}
        title = entry?.title ?? "Create an Entry"
        entryTitleTextField.text = entry?.title
        entryBodyTextView.text = entry?.bodyText
    }
}

