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
	@IBOutlet var moodControl: UISegmentedControl!

	override func viewDidLoad() {
		updateViews()
	}

	private func updateViews() {
		guard isViewLoaded else { return }
		navigationItem.title = entry?.title ?? "Create New Entry"
		titleTextField.text = entry?.title
		entryTextView.text = entry?.bodyText
		if let mood = entry?.mood {
			moodControl.selectedSegmentIndex = Int(mood)
		}
	}

	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
		guard let title = titleTextField.text, !title.isEmpty,
			let bodyText = entryTextView.text, !bodyText.isEmpty else { return }

		let moodIndex = Int16(moodControl.selectedSegmentIndex)
		let mood = Mood(rawValue: moodIndex) ?? Mood.eh

		if let entry = entry {
			entryController?.update(withTitle: title, andBody: bodyText, andMood: mood, onEntry: entry)
		} else {
			entryController?.create(entryWithTitle: title, andBody: bodyText, andMood: mood)
		}

		navigationController?.popViewController(animated: true)
	}
}

