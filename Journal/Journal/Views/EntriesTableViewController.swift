//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Bobby Keffury on 10/2/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit
import CoreData


class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
        cell.entry = entryController.entries[indexPath.row]
        
        return cell
    }


   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let moc = CoreDataStack.shared.mainContext
            
            let entry = entryController.entries[indexPath.row]
            
            entryController.Delete(entry: entry)
            
            do {
                
                try moc.save()
                tableView.reloadData()
            } catch {
                moc.reset()
                print("Error saving managed object context: \(error)")
            }
            
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateEntry" {
            if let detailVC = segue.destination as? EntryDetailViewController {
                detailVC.entryController = entryController
            }
        } else if segue.identifier == "ShowEntryDetail" {
            if let detailVC = segue.destination as? EntryDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entryController = entryController
                detailVC.entry = entryController.entries[indexPath.row]
            }
        }
    }
    

}
