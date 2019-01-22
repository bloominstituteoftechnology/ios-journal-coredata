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
            tableView.deleteRows(at: [indexPath], with: .fade)
            entryController.delete(entry: entryInRow)
    }
    }
 

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "create" {
            
            guard let destination = segue.destination as? EntryDetailViewController else { return }
           
            destination.entryController = entryController
            
        } else if segue.identifier == "detail" {
            guard let destination = segue.destination as? EntryDetailViewController else { return }
            if let tappedRow = tableView.indexPathForSelectedRow {
                destination.entry = entryController.entries[tappedRow.row]
            }
        }
    }
    

}
