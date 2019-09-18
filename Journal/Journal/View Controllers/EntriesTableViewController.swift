//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit
import CoreData


class EntriesTableViewController: UITableViewController {

	let entryController = EntryController()

	lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {

		let fetchRequest

	}


    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return entryController.loadFromPersistentStore().count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
		let entry = entryController.entry[indexPath.row]
		cell.entry = entry
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

			let entry = entryController.entry[indexPath.row]

			entryController.deleteEntry(entry: entry)
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
			guard let detailVC = segue.destination as? EntryDetailViewController,
				let indexPath = tableView.indexPathForSelectedRow else { return }
			detailVC.entry = entryController.entry[indexPath.row]
			detailVC.entryController = entryController
		} else if segue.identifier == "CreateNewEntrySegue" {
			guard let detailVC = segue.destination as? EntryDetailViewController else { return }
			detailVC.entryController = entryController
		}
    }
}
