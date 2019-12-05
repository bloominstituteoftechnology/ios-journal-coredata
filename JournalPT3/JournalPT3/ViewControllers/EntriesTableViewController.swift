//
//  EntriesTableViewController.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)  as? EntryTableViewCell else { return UITableViewCell() }
        
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry: entry)
            tableView.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowAddEntry" {
            if let detailVC = segue.destination as? EntryViewController {
                detailVC.entryController = entryController
            }
        } else if segue.identifier == "ShowDetailView" {
            if let detailVC = segue.destination as? EntryViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entryController = entryController
                detailVC.entry = entryController.entries[indexPath.row]
            }
        }
    }
}
