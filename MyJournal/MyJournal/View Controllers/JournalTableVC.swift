//
//  JournalTableVC.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import CoreData

class JournalTableVC: UITableViewController {

	//MARK: - IBOutlets
	
	
	//MARK: - Properties
	
	let journalController = JournalController()
	
	// This is not a good, nor efficient way of fetching objects!
	// We'll learn a better method tomorrow!
	var entries: [Entry] {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		let moc = CoreDataStack.shared.mainContext
		
		do {
			let entries = try moc.fetch(fetchRequest)
			return entries
		} catch {
			NSLog("Error fetching journal: \(error)")
			return []
		}
	}
	
	//MARK: - Life Cycle
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
	}
	
	
	
	//MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let manageEntryVC = segue.destination as? ManageEntryVC {
			manageEntryVC.journalController = journalController
			
			if let indexPath = tableView.indexPathForSelectedRow {
				manageEntryVC.entry = entries[indexPath.row]
			}
		}
	}
	
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryCell else { return UITableViewCell() }

		cell.entry = entries[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			journalController.delete(entry: entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
