//
//  EntriesTableViewController.swift
//  JournalCoreData
//
//  Created by John Holowesko on 2/13/20.
//  Copyright © 2020 John Holowesko. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    
    // MARK: - Properties
    
    let entryController = EntryController()
    
    // MARK: - View Lifecycle
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
        cell.entry = entryController.entries[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateJournalSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            detailVC.entryController = entryController
        }
        if segue.identifier == "ShowJournalDetailSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.entry = entryController.entries[indexPath.row]
            detailVC.entryController = entryController
        }
    }
}
