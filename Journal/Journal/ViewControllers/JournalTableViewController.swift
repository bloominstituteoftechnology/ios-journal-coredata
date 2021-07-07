//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Propeties
    
    let entryController = EntryController()
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Keys.entryCellName, for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        if entryController.entries.count > 0 {
            let entry = entryController.entries[indexPath.row]
            cell.entry = entry
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath],
                                 with: .fade)
            entryController.saveToPersistence()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.addEntrySegue {
            if let addEntryVC = segue.destination as? EntryDetailViewController {
                addEntryVC.entryController = entryController
            }
        }
        if segue.identifier == Keys.viewEditEntrySegue {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let editEntryVC = segue.destination as? EntryDetailViewController else { return }
            editEntryVC.entryController = entryController
            editEntryVC.entry = entryController.entries[indexPath.row]
        }
    }
}
