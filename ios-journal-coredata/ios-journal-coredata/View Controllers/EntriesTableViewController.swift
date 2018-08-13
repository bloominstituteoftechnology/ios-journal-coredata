//
//  EntriesTableViewController.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/13/18.
//  Copyright © 2018 Conner. All rights reserved.
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


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.deleteEntry(entry: entryController.entries[indexPath.row])
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateNewEntry" {
            if let newEntryVC = segue.destination as? EntryDetailViewController {
                newEntryVC.entryController = entryController
            }
        } else if segue.identifier == "ShowExistingEntry" {
            if let existingEntryVC = segue.destination as? EntryDetailViewController {
                
                existingEntryVC.entryController = entryController
                
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    existingEntryVC.entry = entryController.entries[indexPath.row]
                }
            }
        }
    }
    
    // MARK: - Properties
    let entryController = EntryController()

}
