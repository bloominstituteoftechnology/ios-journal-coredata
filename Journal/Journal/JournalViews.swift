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
			let df = DateFormatter()
			df.dateFormat = "dd/mm/yy HH:mm"
			dateLabel.text = df.string(from: entry.timestamp!)
			print(dateLabel.text ?? "nothing");
		}
	}
}

class EntryListTVC:UITableViewController, NSFetchedResultsControllerDelegate
{
	var controller = EntryController.shared
	var fetcher:NSFetchedResultsController<JournalEntry>!

	override func viewDidLoad()
	{
		fetcher = controller.fetchController
		fetcher.delegate = self
		tableView.reloadData()
	}

	override func viewWillAppear(_ animated: Bool)
	{
	}

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			tableView.insertSections(IndexSet(integer:sectionIndex), with: .automatic)
		case .delete:
			tableView.deleteSections(IndexSet(integer:sectionIndex), with: .automatic)
		default:
			break
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			print(">>> inserting")
			guard let path = newIndexPath else {return}
			tableView.insertRows(at: [path], with: .automatic)
		case .delete:
			print(">>> deleting")
			guard let path = indexPath else {return}
			tableView.deleteRows(at: [path], with: .automatic)
		case .update:
			print(">>> updating")
			guard let path = indexPath else {return}
			tableView.reloadRows(at: [path], with: .automatic)
		case .move:
			print(">>> moving")
			guard let path = indexPath, let newPath = newIndexPath else {return}
			tableView.deleteRows(at: [path], with: .automatic)
			tableView.insertRows(at: [newPath], with: .automatic)
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return fetcher.sections!.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return fetcher.sections![section].numberOfObjects
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let defaultCell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
		guard let cell = defaultCell as? EntryCell else {return defaultCell}
		cell.entry = fetcher.object(at: indexPath)
		return cell
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
	{
		if editingStyle == .delete {
			let entry = fetcher.object(at: indexPath)
			controller.delete(entry)
			controller.save()
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fetcher.sections![section].name
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
			entry.title = title
			entry.text = text
			entry.mood = mood.rawValue
		} else {
			entryList.controller.create(title, text, mood)
		}

		entryList.controller.save(withReset: false)


		navigationController?.popViewController(animated: true)
	}
}
