//
//  EntriesTableViewController.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

	let entryController = EntryController()

	var entries: [Entry] {
		return entryController.loadFromPersistentStore()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

		let entry = entries[indexPath.row]
		cell.entry = entry

        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
			entryController.deleteEntry(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
	

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetailSegue" {
			guard let detailVC = segue.destination as? EntryDetailViewController,
				let indexPath = tableView.indexPathForSelectedRow else { return }
			detailVC.entry = entries[indexPath.row]
			detailVC.entryController = entryController
		} else if segue.identifier == "AddEntrySegue" {
			guard let detailVC = segue.destination as? EntryDetailViewController else { return }
			detailVC.entryController = entryController
		}
    }
}
