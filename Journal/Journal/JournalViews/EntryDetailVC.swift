
import Foundation
import UIKit
import CoreData

class EntryDetailVC:UIViewController
{
	var entryList:EntryListTVC!
	@IBOutlet weak var titleField: UITextField!
	@IBOutlet weak var moodSelector: UISegmentedControl!
	@IBOutlet weak var textField: UITextView!
	var entry:JournalEntry!

	override func viewWillAppear(_ animated: Bool) {
		if let entry = entry {
			titleField.text = entry.title
			textField.text = entry.text
			let index = EntryMood.all.map({$0.rawValue}).index(of:entry.mood) ?? 2
			moodSelector.selectedSegmentIndex = index
		} else {
			moodSelector.selectedSegmentIndex = 2
		}
	}

	@IBAction func saveEntry(_ sender: Any) {
		guard let title = titleField.text, title != "",
			let text = textField.text, text != "" else {
				return
		}

		let mood = EntryMood.all[moodSelector.selectedSegmentIndex]

		if let entry = entry {
			let stub = EntryStub(
				title:title, text:text,
				timestamp:entry.timestamp ?? Date(),
				identifier:entry.identifier ?? UUID().uuidString,
				mood:mood.rawValue)

			entryList.controller.updateEntryWithStub(entry, stub)
		} else {
			entryList.controller.create(title, text, mood)
		}

		entryList.controller.save(withReset: false)


		navigationController?.popViewController(animated: true)
	}
}
