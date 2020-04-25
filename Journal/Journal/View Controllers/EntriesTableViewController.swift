//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Bree Jeune on 4/24/20.
//  Copyright © 2020 Young. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        cell.entry = entryController.entries[indexPath.row]

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateEntry" {
            let createVC = segue.destination as! EntryDetailViewController
            createVC.entryController = entryController

        } else if segue.identifier == "ShowEntryDetail" {
            let detailVC = segue.destination as! EntryDetailViewController
            detailVC.entryController = entryController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entry = entryController.entries[indexPath.row]
            }

        }
    }

    // MARK: - Properties
    
    let entryController = EntryController()

}
