//
//  EntryTableViewController.swift
//  Journal
//
//  Created by brian vilchez on 9/16/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {
    
    let entryController = EntryController()

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
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
            let entry = entryController.entries[indexPath.row]
            cell.entry = entry
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EntryDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let entryDetailVC = segue.destination as? EntryDetailViewController else {return}
                let entry = entryController.entries[indexPath.row]
                entryDetailVC.entry = entry
            entryDetailVC.entryController = entryController

        } else if segue.identifier == "AddEntry" {
            guard let addEntryVC = segue.destination as? EntryDetailViewController else {return}
                addEntryVC.entryController = entryController
        }
    }


}
