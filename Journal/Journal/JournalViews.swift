//
//  JournalViews.swift
//  Journal
//
//  Created by William Bundy on 8/13/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EntryCell:UITableViewCell
{
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var etextLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	var entry:JournalEntry! {
		didSet {
			titleLabel.text = entry.title
			etextLabel.text = entry.text
			dateLabel.text = ""
		}
	}
}

class EntryListTVC:UITableViewController
{
	var innerEntries:[JournalEntry]?
	var entries:[JournalEntry] {
		if innerEntries == nil {
			let req:NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
			do {
				innerEntries = try CoreDataStack.shared.mainContext.fetch(req)
			} catch {
				NSLog("Error fetching tasks \(error)")
			}
		}
		return innerEntries ?? []
	}

	func refreshEntries()
	{
		innerEntries = nil
	}

	override func viewWillAppear(_ animated: Bool)
	{
		tableView.reloadData()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return entries.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let defaultCell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
		guard let cell = defaultCell as? EntryCell else {return defaultCell}
		cell.entry = entries[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
	{
		if editingStyle == .delete {
			let moc = CoreDataStack.shared.mainContext
			let entry = entries[indexPath.row]
			moc.delete(entry)
			refreshEntries()
			do { try moc.save() } catch {
				moc.reset()
				return
			}
			tableView.deleteRows(at: [indexPath], with: .left)
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let dest = segue.destination as? EntryDetailVC {
			dest.entryList = self
			if let cell = sender as? EntryCell {
				dest.entry = cell.entry
			}
		}
	}

}

class EntryDetailVC:UIViewController
{
	var entryList:EntryListTVC!
	@IBOutlet weak var titleField: UITextField!
	@IBOutlet weak var textField: UITextView!
	var entry:JournalEntry!

	override func viewWillAppear(_ animated: Bool) {
		if let entry = entry {
			titleField.text = entry.title
			textField.text = entry.text
		}
	}

	@IBAction func saveEntry(_ sender: Any) {
		guard let title = titleField.text, title != "",
			let text = textField.text, text != "" else {
				return
		}

		let moc = CoreDataStack.shared.mainContext
		if let entry = entry {
			entry.text = text
			entry.title = title
		} else {
			let _ = JournalEntry(title, text)
		}

		do { try moc.save() } catch {
			NSLog("Error saving journal entry")
		}
		entryList.refreshEntries()
		navigationController?.popViewController(animated: true)
	}
}
