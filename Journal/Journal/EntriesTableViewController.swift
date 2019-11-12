//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
  
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entryController.delete(entry: entryController.entries[indexPath.row])
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue" {
            if let addVC = segue.destination as? EntryDetailViewController {
                addVC.entryController = entryController
            }
        } else if segue.identifier == "DetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let DetailVC = segue.destination as? EntryDetailViewController {
                DetailVC.entry = entryController.entries[indexPath.row]
                DetailVC.entryController = entryController
            }
        }
    }
}
