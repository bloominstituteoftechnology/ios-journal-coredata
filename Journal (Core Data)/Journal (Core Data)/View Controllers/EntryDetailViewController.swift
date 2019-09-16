//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/16/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

@IBDesignable class EntryDetailViewController: UIViewController {
    
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

        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.darkGray.cgColor
        descriptionTextView.layer.cornerRadius = 6.0
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            self.title = entry?.title ?? "Create Entry"
            if entry != nil {
                self.titleTextField.text = entry?.title
                self.descriptionTextView.text = entry?.bodyText
            }
        }
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let titleText = titleTextField.text,
            !titleText.isEmpty,
            let bodyText = descriptionTextView.text,
            !bodyText.isEmpty else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: titleText, bodyText: bodyText)
        } else {
            entryController?.createEntry(title: titleText, bodyText: bodyText, timeStamp: Date())
        }
        
        navigationController?.popViewController(animated: true)
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
