//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Craig Swanson on 12/3/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    // Create a new instance of EntryController to access the array and the helper methods.
    var entryController = EntryController()

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell()}

        cell.entry = entryController.entries[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(for: entry)
            tableView.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJournalDetailSegue" {
            guard let entryDetailVC = segue.destination as? EntryDetailViewController else { return }
            if let indexPath = tableView.indexPathForSelectedRow {
                entryDetailVC.entryController = entryController
                entryDetailVC.entry = entryController.entries[indexPath.row]
            }
        } else {
            guard let newEntryVC = segue.destination as? EntryDetailViewController else { return }
            newEntryVC.entryController = entryController
        }
    }

}
