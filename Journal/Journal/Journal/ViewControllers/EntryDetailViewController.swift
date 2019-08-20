//
//  EnteryDetailViewController.swift
//  Journal
//
//  Created by Taylor Lyles on 8/19/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit


enum Moods: String {
	case 0 = "Happy"
	case 1 = "Silly"
	case 2 = "Deep thought"
}

class EntryDetailViewController: UIViewController {
	
	var entry: Entry? {
		didSet {
			updateViews()
		}
	}
	
	var entryController: EntryController?

	@IBOutlet weak var moodSegmentController: UISegmentedControl!
	@IBOutlet weak var enteryTextField: UITextField!
	@IBOutlet weak var enteriesTextView: UITextView!
	
	func updateViews() {
		if entry != nil {
			title = entry?.title
			enteryTextField.text = entry?.title
			enteriesTextView.text = entry?.bodyText
			moodSegmentController.selectedSegmentIndex = entry?.mood
		} else {
			title = "Create Entry"
		}
	}
	
	@IBAction func save(_ sender: Any) {
		guard let title = enteryTextField.text,
			let mood = moodSegmentController.titleForSegment(at: 0),
			let bodyText = enteriesTextView.text else { return }
		
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
