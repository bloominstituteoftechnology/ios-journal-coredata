//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Andrew Ruiz on 10/14/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDetailCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // TODO: "Cannot use mutating member on immutable value
            // entryController.entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // AddJournalEntry
        // ShowJournalEntry
        
        if segue.identifier == "ShowJournalEntry" {
            
            if let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                detailVC.entry = entryController.entries[indexPath.row]
                detailVC.entryController = entryController
            }
        } else if segue.identifier == "AddJournalEntry" {
            
            if let detailVC = segue.destination as? EntryDetailViewController{
                detailVC.entryController = entryController
            }
        }
    }
}
