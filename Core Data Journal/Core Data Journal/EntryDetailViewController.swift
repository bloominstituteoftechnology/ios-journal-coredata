//
//  EntryDetailViewController.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
	var entryController: EntryController?
	var entry: Entry? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var entryTextView: UITextView!

	override func viewDidLoad() {
		updateViews()
	}

	private func updateViews() {
		guard isViewLoaded else { return }
		navigationItem.title = entry?.title ?? "Create New Entry"
		titleTextField.text = entry?.title
		entryTextView.text = entry?.bodyText
	}

	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
		guard let title = titleTextField.text, !title.isEmpty,
			let bodyText = entryTextView.text, !bodyText.isEmpty else { return }

		if let entry = entry {
			entryController?.update(withTitle: title, andBody: bodyText, onEntry: entry)
		} else {
			entryController?.create(entryWithTitle: title, andBody: bodyText)
		}

		navigationController?.popViewController(animated: true)
	}
}

