//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Lydia Zhang on 3/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    var entryController = EntryController()
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        // Configure the cell...
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.delete(entry: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddSegue" {
            if let addVC = segue.destination as? EntryDetailViewController {
                addVC.entryController = entryController
            }
        if segue.identifier == "DetailSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
                let index = tableView.indexPathForSelectedRow else {return}
            detailVC.entry = entryController.entries[index.row]
            detailVC.entryController = entryController
                
            }
        }
    }
    

}
