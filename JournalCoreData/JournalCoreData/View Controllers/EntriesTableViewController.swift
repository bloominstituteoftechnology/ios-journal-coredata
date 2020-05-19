//
//  EntriesTableViewController.swift
//  JournalCoreData
//
//  Created by Enrique Gongora on 2/24/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    //MARK: - Properties
    var entryController = EntryController()
    
    //MARK: - View LifeCycle
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
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(for: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntrySegue" {
            if let createDetailVC = segue.destination as? EntryDetailViewController {
                createDetailVC.entryController = entryController
            }
        } else if segue.identifier == "ShowEntrySegue" {
            guard let showDetailVC = segue.destination as? EntryDetailViewController, let selectedIndex = tableView.indexPathForSelectedRow else { return }
            showDetailVC.entryController = entryController
            showDetailVC.entry = entryController.entries[selectedIndex.row]
        }
    }
}
