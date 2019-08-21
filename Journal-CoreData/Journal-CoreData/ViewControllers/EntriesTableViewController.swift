//
//  EntriesTableViewController.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

	let entryController = EntryController()

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		let timeDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
		let moodDescriptor = NSSortDescriptor(key: "mood", ascending: true)
		fetchRequest.sortDescriptors = [moodDescriptor, timeDescriptor]
		let moc = CoreDataStack.shared.mainContext
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
		frc.delegate = self
		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		return frc
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
		tableView.separatorColor = #colorLiteral(red: 0.6629147508, green: 0.8524925693, blue: 0.8536036969, alpha: 1)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
		returnedView.backgroundColor = UIColor(red: 0.18, green: 0.20, blue: 0.25, alpha: 1.00)
		let label = UILabel(frame: CGRect(x: 10, y: 0, width: 24, height: 24))
		label.text = fetchedResultsController.sections?[section].name
		returnedView.addSubview(label)
		return returnedView
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

		let entry = fetchedResultsController.object(at: indexPath)
		cell.entry = entry

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
			entryController.deleteEntry(entry: entry)
        }
    }
	

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetailSegue" {
			guard let detailVC = segue.destination as? EntryDetailViewController,
				let indexPath = tableView.indexPathForSelectedRow else { return }
			detailVC.entry = fetchedResultsController.object(at: indexPath)
			detailVC.entryController = entryController
		} else if segue.identifier == "AddEntrySegue" {
			guard let detailVC = segue.destination as? EntryDetailViewController else { return }
			detailVC.entryController = entryController
		}
    }
}

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		let sectionIndexSet = IndexSet(integer: sectionIndex)

		switch type {
		case .insert:
			tableView.insertSections(sectionIndexSet, with: .fade)
		case .delete:
			tableView.deleteSections(sectionIndexSet, with: .fade)
		default:
			break
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .fade)
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .fade)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .fade)
		default:
			fatalError()
		}
	}
}
