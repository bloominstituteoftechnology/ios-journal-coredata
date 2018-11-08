//
//  EntriesTable.swift
//  Journal
//
//  Created by Lotanna Igwe-Odunze on 11/7/18.
//  Copyright © 2018 Lotanna. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EntriesTable: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entries.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "entryCell")
        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("Error deleting task, undid delete: \(error)" )
            }
            tableView.reloadData()
        }
    }
    
    //Reload the Table View
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    //Prepare for Segue
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewEntries", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEntries" {
            let detailVC = segue.destination as! AddEditEntryView
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entry = entries[indexPath.row]
            }
        }
    }
}
