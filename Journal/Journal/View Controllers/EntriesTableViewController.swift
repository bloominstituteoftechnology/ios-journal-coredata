//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Thomas Cacciatore on 6/10/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

  
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { fatalError("Unable to dequeue cell") }
        
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry

        return cell
    }
  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry: entry)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue" {
            let destinationVC = segue.destination as! EntryDetailViewController
            destinationVC.entryController = entryController
        } else if segue.identifier == "CellSegue" {
            let destinationVC = segue.destination as! EntryDetailViewController
            guard let index = tableView.indexPathForSelectedRow else { return }
            destinationVC.entry = entryController.entries[index.row]
            destinationVC.entryController = entryController
        }
    }

 
    var entryController = EntryController()
}
