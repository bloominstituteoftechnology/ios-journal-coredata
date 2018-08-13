//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Samantha Gatt on 8/13/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        let thisEntry = entryController.entries[indexPath.row]
        cell.entry = thisEntry

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let thisEntry = entryController.entries[indexPath.row]
            entryController.delete(entry: thisEntry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! EntryDetailViewController
        destVC.entryController = entryController
        if segue.identifier == "ShowEntryDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let thisEntry = entryController.entries[indexPath.row]
            destVC.entry = thisEntry
        }
    }

    // MARK: - Properties
    
    let entryController = EntryController()
}
