//
//  EntriesTableViewController.swift
//  JournalCoreData
//
//  Created by scott harris on 2/24/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
        let entry = entryController.entries[indexPath.row]
        
        cell.entry = entry
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntryModalSegue" {
            if let createDetailVC = segue.destination as? EntryDetailViewController {
                createDetailVC.entryController = entryController
            }
            
        } else if segue.identifier == "ShowEntrySegue" {
            if let showDetailVC = segue.destination as? EntryDetailViewController {
                showDetailVC.entryController = entryController
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    showDetailVC.entry = entryController.entries[selectedIndex.row]
                }
                
            }
        }
    }
    
}
