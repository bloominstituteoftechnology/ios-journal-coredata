//
//  EntryDetailViewController.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/13/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    //MARK: - Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    //MARK: - Methods
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else {return}
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText)
        } else {
            entryController?.create(title: title, bodyText: bodyText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateViews() {
        guard isViewLoaded else {return}
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
    }
    
}
