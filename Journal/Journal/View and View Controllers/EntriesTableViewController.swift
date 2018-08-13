//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Andrew Liao on 8/13/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        cell.entry = entryController.entries[indexPath.row]
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entryController.entries[indexPath.row])
            if entryController.saveToPersistentStore() {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EntryDetailViewController
        
        if segue.identifier == "ViewEntry"{
            guard let index = tableView.indexPathForSelectedRow?.row  else {return}
            destinationVC.entry = entryController.entries[index]
            destinationVC.entryController = entryController
        }
        if segue.identifier == "CreateEntry"{
            destinationVC.entryController = entryController
        }
        
    }
    
    let entryController = EntryController()
    
}
