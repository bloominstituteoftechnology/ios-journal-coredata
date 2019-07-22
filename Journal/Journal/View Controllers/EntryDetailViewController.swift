//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!

    
    var entry: Entry? {
        didSet {
            self.updateViews()
        }
    }
    var entryController: EntryController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.delegate = self
        updateViews()
        
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty else { return }
        
        if let entry = entry {
            self.entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
        } else {
            self.entryController?.createEntry(title: title, bodyText: bodyText)
        }
        
        navigationController?.popViewController(animated: true)
    }

    
    
    func updateViews() {
        
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        let placeHolder = "Enter your text"
        bodyTextView.text = entry?.bodyText ?? placeHolder
        if bodyTextView.text == placeHolder {
            bodyTextView.textColor = UIColor.lightGray
        } else {
            bodyTextView.textColor = UIColor.black
        }
        
    }

}


extension EntryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your text"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
