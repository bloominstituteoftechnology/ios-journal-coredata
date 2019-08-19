//
//  EnteriesTableViewController.swift
//  Journal
//
//  Created by Taylor Lyles on 8/19/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class EnteriesTableViewController: UITableViewController {
	
	let entryController = EntryController()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
		
		let entry = entryController.entries[indexPath.row]
		cell.entry = entry
		cell.updateViews()

        return cell
    }
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
		
		let entry = entryController.entries[indexPath.row]
		entryController.deleteEntry(entry: entry)
		tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddShowSegue" {
			guard let newEntryVC = segue.destination as? EntryDetailViewController,
				let indexPath = tableView.indexPathForSelectedRow else { return }
			
			newEntryVC.entry = entryController.entries[indexPath.row]
			newEntryVC.entryController = entryController
		} else {
			guard let selectedEntryVC = segue.destination as? EntryDetailViewController else { return }
			
			selectedEntryVC.entryController = entryController
		}
	}
}
