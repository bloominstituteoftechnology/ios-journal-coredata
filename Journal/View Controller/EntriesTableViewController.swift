//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Hayden Hastings on 6/3/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        let entry = entryController.entries[indexPath.row]
        
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? EntryDetailViewController else { return }
        if segue.identifier == "JournalCell" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            detailVC.entry = entry
            detailVC.entryController = entryController
        } else if segue.identifier == "toDetailVC" {
            detailVC.entryController = entryController
        }
    }
    
    let entryController = EntryController()

}
