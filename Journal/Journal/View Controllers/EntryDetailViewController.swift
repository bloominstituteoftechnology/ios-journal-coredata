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
	@IBOutlet weak var moodSegmentedControl: UISegmentedControl!
	
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

	@IBAction func saveButtonTapped(_ sender: Any) {
		if let title = titleTextField.text,
			let text = textViewField.text {

			let index = moodSegmentedControl.selectedSegmentIndex

			let mood: String

			switch index {
			case 0:
				mood = MoodStates.sad.rawValue
			case 1:
				mood = MoodStates.happy.rawValue
			default:
				mood = MoodStates.normal.rawValue
			}

		// Pass it into the create and update Entry functions below

		//Either save a new entry or update the existing entry
		if let entry = entry {
			entryController?.updateEntry(entry: entry, title: title, bodyText: text, mood: mood)
		} else {
			entryController?.createEntry(title: title, bodyText: text, mood: mood)
		}
		}
		navigationController?.popViewController(animated: true)
	}

	//
	func updateViews() {
		guard isViewLoaded,
		let entry = entry else { return }

		title = entry.title ?? "Create Entry"
		titleTextField.text = entry.title
		textViewField.text = entry.bodyText

//		if let mood = MoodStates(rawValue: entry?.mood ?? "😕"),
//			let moodIndex = MoodStates.allCases.firstIndex(of: mood) {
//
//			moodSegmentedControl.selectedSegmentIndex = moodIndex
//
//		}

			switch entry.mood {
			case MoodStates.sad.rawValue:
				moodSegmentedControl.selectedSegmentIndex = 0
			case MoodStates.normal.rawValue:
				moodSegmentedControl.selectedSegmentIndex = 1
			case MoodStates.happy.rawValue:
				moodSegmentedControl.selectedSegmentIndex = 2
			default:
				break
		}
}
}

