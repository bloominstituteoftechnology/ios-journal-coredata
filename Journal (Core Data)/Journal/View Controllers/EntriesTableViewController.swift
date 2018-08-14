//
//  EntriesTableViewController.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController =  EntryController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        // Set cell's entry to the entry at the specific indexPath
        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Get the entry at the cell we want to delete
            let entry = entryController.entries[indexPath.row]
            
            entryController.delete(entry: entry)
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowEntryDetail" {
//            let detailVC = segue.destination as! EntryDetailViewController
//            detailVC.entryController = entryController
//
//            // Get indexPath of selected cell
//            if let indexPath = tableView.indexPathForSelectedRow?.row {
//                // Setting the entry at that indexPath to the detailVC's entry property
//                detailVC.entry = entryController.entries[indexPath]
//            }
//        } else if segue.identifier == "ShowAddEntry" {
//            let detailVC = segue.destination as! EntryDetailViewController
//            detailVC.entryController = entryController
//        }

        if let detailVC = segue.destination as? EntryDetailViewController {
            detailVC.entryController = entryController
            
            if segue.identifier == "ShowEntryDetail" {
                if let indexPath = tableView.indexPathForSelectedRow?.row {
                    // Setting the entry at that indexPath to the detailVC's entry property
                    detailVC.entry = entryController.entries[indexPath]
                }
            }
        }
    }
}
