//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - IBActions & Methods
    
    private func updateViews() {
        if let entry = entry,
            isViewLoaded {
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else { return }
        let timeInterval = TimeInterval(NSDate().timeIntervalSince1970)
        let timeStamp = Date(timeIntervalSince1970: timeInterval)
        
        if let entry = entry,
           let entryController = entryController {
            entryController.updateEntry(entry: entry, with: title, bodyText: bodyText, identifier: "1", timeStamp: timeStamp)
        }else {
            guard let entryController = entryController else { return }
            entryController.createEntry(with: title, bodyText: bodyText, identifier: "1", timeStamp: timeStamp)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
}
