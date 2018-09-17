//
//  EntriesListTableViewController.swift
//  Journal
//
//  Created by Jason Modisett on 9/17/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import UIKit

class EntriesListTableViewController: UITableViewController {

    // MARK:- View lifecycle methods
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
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? EntryDetailsViewController else { return }
        destVC.entryController = entryController
        
        if segue.identifier == "EntryDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let entry = entryController.entries[indexPath.row]
            destVC.entry = entry
        }
    }
    
    // MARK:- Properties & types
    var entryController = EntryController()
    
}
