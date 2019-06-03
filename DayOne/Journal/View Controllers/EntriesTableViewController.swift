//
//  EntriesTableViewController.swift
//  Journal - Day One
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    // MARK: -View states
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    
    // MARK: - Delete function
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete this object
            entryController.delete(delete: entryController.entries[indexPath.row])
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewEntrySegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
                detailVC.entryController = entryController
                detailVC.entry = entryController.entries[indexPath.row]
        } else {
            if segue.identifier == "AddEntrySegue" {
                guard let detailVC = segue.destination as? EntryDetailViewController else { return }
                detailVC.entryController = entryController
            }
        }
        
        
    }
    
    // MARK: - Properties
    let entryController = EntryController()

}
