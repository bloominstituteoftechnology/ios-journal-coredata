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
	@IBOutlet weak var feelingSegControl: UISegmentedControl!
	
	//MARK: - Properties
	
	var journalController: JournalController!
	var entry: Entry?
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSegControl()
		updateViews()
	}
	
	//MARK: - IBActions
	
	@IBAction func saveBtnTapped(_ sender: Any) {
		guard let title = titleTextField.optionalText else { return }
		let story = storyTextView.text
		let emoji = EntryEmoji.allCases[feelingSegControl.selectedSegmentIndex]
		if let entry = entry {
			journalController.updateEntry(entry: entry, title: title, story: story, entryFeeling: emoji)
		} else {
			journalController.createEntry(title: title, story: story, entryFeeling: emoji)
		}
		okAction(message: entry == nil ? "New journal entry created." : "Journal entry updated.")
	}
	
	//MARK: - Helpers
	
	private func setupSegControl() {
		feelingSegControl.removeAllSegments()
		for index in 0..<EntryEmoji.allCases.count {
			feelingSegControl.insertSegment(withTitle: EntryEmoji.allCases[index].rawValue, at: index, animated: true)
		}
		feelingSegControl.selectedSegmentIndex = EntryEmoji.defaultIndex
	}
	
	private func updateViews() {
		guard let entry = entry else { return }
		titleTextField.text = entry.title
		storyTextView.text = entry.story
		if let feelingEmoji = entry.feelingEmoji, let emoji = EntryEmoji(rawValue: feelingEmoji) {
			let emojiIndex = EntryEmoji.allCases.firstIndex(of: emoji) ?? EntryEmoji.defaultIndex
			feelingSegControl.selectedSegmentIndex = emojiIndex
		}
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
