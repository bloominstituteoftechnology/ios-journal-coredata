//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {
    //MARK: Properties
    let entryController = EntryController()

    //MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ENTRYCELLIDENTIFIER, for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    
    //MARK: Delete TableView Rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entryController.deleteEntry(entry: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ADDENTRYSEGUE {
            if let destination = segue.destination as? UINavigationController {
                let destinationController = destination.topViewController as! JournalDetailViewController
                destinationController.entryController = entryController
            }
        } else if segue.identifier == ENTRYDETAILSEGUE {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destination = segue.destination as? JournalDetailViewController
            else {return}
            destination.journalEntry = entryController.entries[indexPath.row]
            destination.entryController = entryController
        }
    }

}
