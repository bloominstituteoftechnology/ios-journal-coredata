//
//  EntriesTableViewController.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
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
        //remeber to cast the cell as EntryTableViewCell, then pass an Entry to the cell's entry property in order for it to call the updateViews() method to fill in the information for the cell's labels.
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
            guard let detailVC = segue.destination as? EntryDetailViewController, let index = tableView.indexPathForSelectedRow else { return }
            let entryToPass = ec.entries[index.row]
            detailVC.entry = entryToPass
            detailVC.ec = ec
        }
    }
}
