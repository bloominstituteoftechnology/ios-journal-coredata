//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Percy Ngan on 10/14/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	// MARK: - Properties
	let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}

	lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
		// This gets every Entry in core data
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()

		fetchRequest.sortDescriptors = [
			NSSortDescriptor(key: "mood", ascending: true),
			NSSortDescriptor(key: "timestamp", ascending: true)]

		let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
											 managedObjectContext: CoreDataStack.shared.mainContext,
											 sectionNameKeyPath: "mood",
											 cacheName: nil)

		frc.delegate = self

		do {
			try frc.performFetch() // The frc doesn't start fetch usless this line is added
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		return frc // Return the frc so that it gets stored in line 28
	}()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return entryController.entries.count
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntriesTableViewCell else { return UITableViewCell() }

		cell.entry = entryController.entries[indexPath.row]

        return cell
    }


	/*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
	*/


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetailSegue" {
			if let detailVC = segue.destination as? EntryDetailViewController,
				let indexPath = tableView.indexPathForSelectedRow {
				detailVC.entry = entryController.entries[indexPath.row]
				detailVC.entryController = entryController
			}
		} else if segue.identifier == "CreateNewEntrySegue" {
			if let detailVC = segue.destination as? EntryDetailViewController {
				detailVC.entryController = entryController
			}
		}
}
}
