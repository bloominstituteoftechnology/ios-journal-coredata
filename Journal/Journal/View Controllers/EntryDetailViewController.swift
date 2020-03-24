//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Wyatt Harrell on 3/23/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.layer.cornerRadius = 8
        descriptionTextView.layer.cornerRadius = 8
        titleTextField.becomeFirstResponder()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        guard let body = descriptionTextView.text, !body.isEmpty else { return }
        
        if let entry = entry {
            entryController?.update(title: title, bodyText: body, entry: entry)
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            entryController?.create(title: title, bodyText: body, timestamp: Date())
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateViews() {
        if isViewLoaded {
            if let entry = entry {
                title = entry.title
                titleTextField.text = entry.title
                descriptionTextView.text = entry.bodyText
            } else {
                title = "Create Entry"
            }
        }
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
