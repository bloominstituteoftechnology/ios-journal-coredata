
import Foundation
import UIKit
import CoreData

class EntryListTVC:UITableViewController, NSFetchedResultsControllerDelegate
{
	var controller = EntryController.shared
	var fetcher:NSFetchedResultsController<JournalEntry>!

	override func viewDidLoad()
	{
		fetcher = controller.fetchController
		fetcher.delegate = self
		controller.fetchRemoteOnBackgroundContext()
		tableView.reloadData()
	}

	override func viewWillAppear(_ animated: Bool)
	{
	}

	@IBAction func refresh(_ sender: Any)
	{
		controller.fetchRemoteOnBackgroundContext() { _ in
			DispatchQueue.main.async {
				self.refreshControl?.endRefreshing()
			}
		}
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
			guard let path = newIndexPath else {return}
			tableView.insertRows(at: [path], with: .automatic)
		case .delete:
			guard let path = indexPath else {return}
			tableView.deleteRows(at: [path], with: .automatic)
		case .update:
			guard let path = indexPath else {return}
			tableView.reloadRows(at: [path], with: .automatic)
		case .move:
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
