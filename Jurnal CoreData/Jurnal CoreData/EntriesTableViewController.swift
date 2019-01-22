//
//  EntriesTableViewController.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    let entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EntryTableViewCell else { fatalError("No such cell")}
        
        
        
            cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
           let entryInRow = entryController.entries[indexPath.row]
            entryController.delete(entry: entryInRow)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
    }
    }
 

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            guard let destination = segue.destination as? EntryDetailViewController else { return }
            destination.entryController = entryController
       
        
         if segue.identifier == "detail" {
            guard let destination = segue.destination as? EntryDetailViewController else { return }
            guard let tappedRow = tableView.indexPathForSelectedRow else { return }
            destination.entry = entryController.entries[tappedRow.row]
         }
        
        }
    }

