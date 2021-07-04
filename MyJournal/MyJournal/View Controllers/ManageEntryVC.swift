//
//  ManageEntryVC:.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class ManageEntryVC: UIViewController {

	//MARK: - IBOutlets
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var storyTextView: UITextView!
	
	//MARK: - Properties
	
	var journalController: JournalController!
	var entry: Entry?
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateViews()
	}
	
	//MARK: - IBActions
	
	@IBAction func saveBtnTapped(_ sender: Any) {
		guard let title = titleTextField.optionalText else { return }
		let story  = storyTextView.text
		
		if let entry = entry {
			journalController.updateEntry(entry: entry, title: title, story: story)
		} else {
			journalController.createEntry(title: title, story: story)
		}
		
		okAction(message: entry == nil ? "New journal entry created." : "Journal entry updated.")
	}
	
	//MARK: - Helpers
	
	private func updateViews() {
		guard let entry = entry else { return }
		
		titleTextField.text = entry.title
		storyTextView.text = entry.story
	}
	
	private func okAction(message: String) {
		let alert = UIAlertController(title: "Saved!", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
			self.navigationController?.popViewController(animated: true)
		}))
		self.present(alert, animated: true)
	}
	
}

extension UITextField {
	var optionalText: String? {
		let trimmedText = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		return (trimmedText ?? "").isEmpty ? nil : trimmedText
	}
}
