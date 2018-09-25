//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Scott Bennett on 9/24/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    weak var delegate: EntryTableViewCell?
    
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
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        
    }

    
    @IBAction func saveButton(_ sender: Any) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else { return }
        
        guard let entry = entry else {
            entryController?.create(title: title, bodyText: bodyText)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
        return
        }
        
        entryController?.update(entry: entry, title: title, bodyText: bodyText)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    
    }

}
