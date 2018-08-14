//
//  EntriesTableViewController.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/13/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    
    //MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as! EntryTableViewCell
        let entry = entryController.entries[indexPath.row]
        
        cell.entry = entry
//        cell.titleLabel.text = entry.title
//        cell.bodyLabel.text = entry.bodyText
//        cell.timestampLabel.text = entry.timestamp?.description
        return cell
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddJournal" {
            let destinationVC = segue.destination as! EntryDetailViewController
            destinationVC.entryController = entryController
        } else if segue.identifier == "ShowDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let destinationVC = segue.destination as! EntryDetailViewController
            destinationVC.entryController = entryController
            destinationVC.entry = entryController.entries[indexPath.row]
        }
    }
 
    
    //MARK: - Properties
    let entryController = EntryController()

}
