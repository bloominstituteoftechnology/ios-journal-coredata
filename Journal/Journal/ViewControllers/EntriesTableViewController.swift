//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    let entryController = EntryController()
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? JournalTableViewCell else {
            return UITableViewCell()
        }
        
        cell.entry = entryController.entries[indexPath.row]
        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry: entry)
            tableView.reloadData()
        }
    }


    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowJournalEntry" {
            guard let vc = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
            else {
                return
            }
            vc.entry = entryController.entries[indexPath.row]
            vc.entryController = entryController
        } else if segue.identifier == "segueAddJournalEntry" {
            guard let vc = segue.destination as? EntryDetailViewController else { return }
            vc.entryController = entryController
        }
    }
}
