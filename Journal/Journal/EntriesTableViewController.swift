//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/5/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import UIKit
import CoreData


class EntriesTableViewController: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    let entryController = EntryController()
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entryController.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryTableViewCell
        
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
                tableView.reloadData()
                
            } catch {
                moc.reset()
                
            }
 
        }
    }
 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let DetailVC = segue.destination as? EntryDetailViewController else {return}
        DetailVC.entryController = entryController

        if segue.identifier == "existingEntries" {
            if let indexPath = tableView.indexPathForSelectedRow {
                DetailVC.entry = entryController.entries[indexPath.row]
            }
        }
    }
    
}
