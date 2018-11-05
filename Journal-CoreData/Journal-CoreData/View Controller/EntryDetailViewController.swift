//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Nikita Thomas on 11/5/18.
//  Copyright © 2018 Nikita Thomas. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBAction func saveButton(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {return}
        guard let text = textView.text, !text.isEmpty else {return}
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: text)
        } else {
            entryController?.newEntry(title: title, bodyText: text)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    var entryController: EntryController?
    
    func updateViews() {
        guard isViewLoaded else {return}
        
        title = entry?.title ?? "Create New Entry"
        titleTextField.text = entry?.title
        textView.text = entry?.bodyText
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
