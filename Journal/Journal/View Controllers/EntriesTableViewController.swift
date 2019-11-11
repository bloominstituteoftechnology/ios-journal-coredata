//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var entryController = EntryController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell
            else {
                print("Cell cannot conform to EntryTableViewCell!")
                return UITableViewCell()
        }
        
        cell.entry = entryController.entries[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewEntryDetailSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
                else {
                    print("Error: failed to cast segue destination as EntryDetailViewController, or failed to get index path for selected row.")
                    return
            }
            
            detailVC.entry = entryController.entries[indexPath.row]
            detailVC.entryController = entryController
        } else if segue.identifier == "NewEntrySegue" {
            guard let addVC = segue.destination as? EntryDetailViewController
                else {
                    print("Error: failed to cast segue destination as EntryDetailViewController.")
                    return
            }
            
            addVC.entryController = entryController
        }
    }

}
