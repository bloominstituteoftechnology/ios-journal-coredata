//
//  EntriesTableViewController.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    // MARK: - Properties

    let entryController = EntryController()
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        guard indexPath.row < entryController.entries.count else { return UITableViewCell() }
        
        cell.entry = entryController.entries[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? EntryDetailViewController else { return }
        
        if segue.identifier == "ShowEntryDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let selectedEntry = entryController.entries[indexPath.row]
            detailVC.entry = selectedEntry
            detailVC.entryController = entryController
            
        } else if segue.identifier == "ShowCreateEntrySegue" {
            detailVC.entryController = entryController
        }
    }

}
