//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Wyatt Harrell on 3/23/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    let entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
        
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
        if segue.identifier == "EntryDetailModalSegue" {
            guard let Nav = segue.destination as? UINavigationController else { return }
            guard let EntryDetailVC = Nav.topViewController as? EntryDetailViewController else { return }
            guard let selected = tableView.indexPathForSelectedRow else { return }
            EntryDetailVC.entryController = entryController
            EntryDetailVC.entry = entryController.entries[selected.row]
        } else if segue.identifier == "NewEntryModalSegue" {
            guard let Nav = segue.destination as? UINavigationController else { return }
            guard let NewEntryVC = Nav.topViewController as? EntryDetailViewController else { return }
            NewEntryVC.entryController = entryController
        }
    }
    

}
