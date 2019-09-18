//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var detailTextField: UITextView!
	@IBOutlet weak var moodSegmentedControl: UISegmentedControl!

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


	// MARK: - Properties

	func updateViews() {
		guard let entry = entry, isViewLoaded else { return }
		title = entry.title
		titleTextField.text = entry.title
		detailTextField.text = entry.bodyText

		if let moodString = entry.mood,
			let mood = Mood(rawValue: moodString) {

			let index = Mood.allCases.firstIndex(of: mood) ?? 0

		moodSegmentedControl.selectedSegmentIndex = index
		}
	}


	// MARK: - Actions

	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let title = titleTextField.text,
			let detailText = detailTextField.text,
			!title.isEmpty,
			!detailText.isEmpty else { return }

		// Using some info from the segmented control, get a Mood from the enum to pass to the function below?
		let index = moodSegmentedControl.selectedSegmentIndex

		let mood = Mood.allCases[index]

//		switch index {
//		case 0:
//			mood = .happy
//		case 1:
//			mood = .sad
//		default:
//			mood = .neutral
//		}

		if let entry = entry {
			entryController?.updateEntry(entry: entry, title: title, bodyText: detailText, mood: mood)
		} else {
			entryController?.createEntry(with: title, bodyText: detailText, mood: mood)
		}
		navigationController?.popViewController(animated: true)
	}


    // MARK: - Navigation



}
