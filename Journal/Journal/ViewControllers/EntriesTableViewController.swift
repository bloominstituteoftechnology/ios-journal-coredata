//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Hector Steven on 5/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
	
	
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultController.sections?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
		
		guard let entryCell = cell as? EntryTableViewCell else { return cell }
		let entry = fetchedResultController.object(at: indexPath)
		entryCell.entry = entry
		return entryCell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			let entry = fetchedResultController.object(at: indexPath)
			let moc = CoreDataStack.shared.mainContext
			
			moc.delete(entry)
			
			do {
				try moc.save()
			} catch {
				NSLog("Error deleting Entry: \(error)")
			}
			
			tableView.reloadData()
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fetchedResultController.sections?[section].name
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultController.sections?[section].numberOfObjects ?? 0
	}
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		@unknown default:
			print("uknow default")
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {
		
		switch type {
		case .insert:
			let indexSet = IndexSet(integer: sectionIndex)
			tableView.insertSections(indexSet, with: .automatic)
		case .delete:
			let indexSet = IndexSet(integer: sectionIndex)
			tableView.deleteSections(indexSet, with: .automatic)
		default:
			break
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetail" {
			guard let vc = segue.destination as? EntryDetailViewController,
				let indexpath = tableView.indexPathForSelectedRow else { return }
			vc.entry = fetchedResultController.object(at: indexpath)
		}
	}
	
	
	
	lazy var fetchedResultController: NSFetchedResultsController<Entry> = {
		
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: true),
										NSSortDescriptor(key: "timeStamp", ascending: true)]
		
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
																  managedObjectContext: CoreDataStack.shared.mainContext,
																  sectionNameKeyPath: "mood",
																  cacheName: nil)
		fetchedResultsController.delegate = self
		
		do {
			try fetchedResultsController.performFetch()
		} catch {
			NSLog("Error performing initial fetch for frc: \(error)")
		}
		
		return fetchedResultsController
	}()
	
}
