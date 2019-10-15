//
//  ViewController.swift
//  Journal
//
//  Created by Percy Ngan on 10/14/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var textViewField: UITextView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	// MARK: - Properties
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
		textViewField.text = entry?.bodyText
	}

	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let title = titleTextField.text,
		let text = textViewField.text,
		!title.isEmpty,
		!text.isEmpty else { return }

		if let entry = entry {
			entryController?.updateEntry(entry: entry, title: title, bodyText: text)
		} else {
			entryController?.createEntry(title: title, bodyText: text)
		}
		navigationController?.popViewController(animated: true)
	}
	


}

