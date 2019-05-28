//
//  EntriesTableViewController.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

	let entryController = EntryController()

	lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		let timestampSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
		fetchRequest.sortDescriptors = [timestampSortDescriptor]

		let moc = CoreDataStack.shared.mainContext
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
																  managedObjectContext: moc,
																  sectionNameKeyPath: "mood",
																  cacheName: nil)
		fetchedResultsController.delegate = self
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("error performing initial fetch for frc: \(error)")
		}
		return fetchedResultsController
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: "EntryCell")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? EntryDetailViewController {
			dest.entryController = entryController
		}
	}
}

// MARK: - table stuff
extension EntriesTableViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fetchedResultsController.sections?[section].indexTitle
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
		guard let entryCell = cell as? EntryTableViewCell else { return cell }

		entryCell.entry = fetchedResultsController.object(at: indexPath)
		return entryCell
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			guard let entryCell = tableView.cellForRow(at: indexPath) as? EntryTableViewCell, let entry = entryCell.entry else { return }
			entryController.delete(entry: entry)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "EntryDetail") as? EntryDetailViewController else { return }
		guard let entry = (tableView.cellForRow(at: indexPath) as? EntryTableViewCell)?.entry else { return }
		detailVC.entryController = entryController
		detailVC.entry = entry

		navigationController?.pushViewController(detailVC, animated: true)
	}
}

// MARK: - Fetched Results Controller Delegate
extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		let indexSet = IndexSet([sectionIndex])
		switch type {
		case .insert:
			tableView.insertSections(indexSet, with: .automatic)
		case .delete:
			tableView.deleteSections(indexSet, with: .automatic)
		default:
			print(#line, #file, "unexpected NSFetchedResultsChangeType: \(type)")
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .move:
			guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		@unknown default:
			print(#line, #file, "unknown NSFetchedResultsChangeType: \(type)")
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		guard let value = Int16(sectionName) else { return nil }
		return Mood(rawValue: value)?.stringValue
	}
}
