//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    let reuseIdentifier = "EntryCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EntryTableViewCell
        
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = entryController.entries[indexPath.row]
            
            entryController.delete(entry: entry)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowEntryDetail" {
            guard let destination = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            
            destination.entryController = entryController
            destination.entry = entry
            
        } else if segue.identifier == "ShowCreateEntry" {
            guard let destination = segue.destination as? EntryDetailViewController else { return }
            
            destination.entryController = entryController
        }
    }
    
    // MARK: - Properties
    
    var entryController = EntryController()
    
}
