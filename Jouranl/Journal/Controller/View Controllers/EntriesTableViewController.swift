//
//  EntriesTableViewController.swift
//  Jouranl
//
//  Created by Joshua Rutkowski on 2/12/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    // MARK: - Properties
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddJournalSegue" {
            if let addVC = segue.destination as? EntryDetailViewController {
                addVC.entryController = entryController
            }
        } else if segue.identifier == "ShowJournalSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let DetailVC = segue.destination as? EntryDetailViewController {
                DetailVC.entry = entryController.entries[indexPath.row]
                DetailVC.entryController = entryController
            }
        }
    }
}
