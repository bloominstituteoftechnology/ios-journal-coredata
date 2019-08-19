//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

	@IBOutlet weak var titleStaticLabel: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var bodyStaticLabel: UILabel!
	@IBOutlet weak var bodyTextView: UITextView!

	var entry: Entry? {
		didSet {
			updateViews()
		}
	}
	var entryController: EntryController?


    override func viewDidLoad() {
        super.viewDidLoad()
		updateViews()
		setupUI()
	}
    
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
		guard let title = titleTextField.text,
			let bodyText = bodyTextView.text,
			!title.isEmpty,
			!bodyText.isEmpty else { return }

		if entry == nil {
			entryController?.createEntry(title: title, bodyText: bodyText, identifier: "")
		} else {
			guard let entry = entry else { return }
			entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
		}
		navigationController?.popViewController(animated: true)
	}


	private func updateViews() {
		guard isViewLoaded else { return }
		titleTextField.text = entry?.title
		bodyTextView.text = entry?.bodyText

		if entry == nil {
			title = "Create Entry"
		} else {
			title = entry?.title
		}
	}

	private func setupUI() {
		bodyTextView.layer.borderWidth = 1
		bodyTextView.layer.borderColor = UIColor(red: 0.66, green: 0.85, blue: 0.85, alpha: 1.00).cgColor
		bodyTextView.layer.cornerRadius = 6
	}
}
