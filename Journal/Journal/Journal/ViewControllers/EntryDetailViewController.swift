//
//  EnteryDetailViewController.swift
//  Journal
//
//  Created by Taylor Lyles on 8/19/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit


enum Mood: String {
	case happy
	case silly
	case deepThought
	
	func indexValue() -> Int {
		switch self {
		case .happy:
			return 0
		case .silly:
			return 1
		case .deepThought:
			return 2
		}
	}

	static func value(for index: Int) -> Mood {
		switch index {
		case 0:
			return .happy
		case 1:
			return .silly
		case 2:
			return .deepThought
		default:
			return .happy
		}
	}
}

class EntryDetailViewController: UIViewController {
	
	var entry: Entry? {
		didSet {
			updateViews()
		}
	}
	
	var entryController: EntryController?

	@IBOutlet weak var moodSegmentController: UISegmentedControl!
	@IBOutlet weak var entryTextField: UITextField!
	@IBOutlet weak var enteriesTextView: UITextView!
	
	func updateViews() {
		
		guard let entry = entry else {
			title = "Create Entry"
			return
		}
		
		title = entry.title
		entryTextField.text = entry.title
		enteriesTextView.text = entry.bodyText
		guard let entryMood = entry.mood else { return }
		let mood = Mood(rawValue: entryMood)
		
		moodSegmentController.selectedSegmentIndex = mood?.indexValue() ?? Mood.happy.indexValue()
	}
	
	@IBAction func save(_ sender: Any) {
		guard let title = entryTextField.text,
			let bodyText = enteriesTextView.text else { return }
		
		let mood = Mood.value(for: moodSegmentController.selectedSegmentIndex)
		
		if entry != nil {
			guard let thisEntry = entry else { return }
			
			entryController?.updateEntry(entry: thisEntry, with: title, bodyText: bodyText, mood: mood)
			navigationController?.popViewController(animated: true)
		} else {
			entryController?.createEntry(with: title, bodyText: bodyText, mood: mood)
			navigationController?.popViewController(animated: true)
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		updateViews()

        // Do any additional setup after loading the view.
    }
}
