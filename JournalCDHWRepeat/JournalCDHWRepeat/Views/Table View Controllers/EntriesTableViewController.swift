//
//  EntriesTableViewController.swift
//  JournalCDHWRepeat
//
//  Created by Michael Flowers on 6/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    let ec = EntryController()
    
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
        return ec.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as! EntryTableViewCell

        // Configure the cell...
        let entryToPass = ec.entries[indexPath.row]
        cell.entry = entryToPass
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryToDelete = ec.entries[indexPath.row]
            ec.delete(entry: entryToDelete)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CellSegue" {
            guard let destinationVC = segue.destination as? EntryDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let entryToPass = ec.entries[indexPath.row]
            destinationVC.entry = entryToPass
            destinationVC.ec = ec
        }
        
        if segue.identifier == "AddSegue" {
            guard let destinationVC = segue.destination as? EntryDetailViewController else { return }
            destinationVC.ec = ec
        }
    }
   

}
