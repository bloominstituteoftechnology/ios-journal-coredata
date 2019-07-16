//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/10/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
//    @IBOutlet var tableView: UITableView!
    
    var entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.backgroundColor = .lightGray
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JornalCell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()
            
        }

        let entry = entryController.entries[indexPath.row]
        
        cell.entry = entry

        return cell
    }
 



    // delete
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddDetail" {
            guard let detailVC = segue.destination as? EntryDetailViewController else {return}
            detailVC.entryController = entryController
        }
        
        if segue.identifier == "JournalCellDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            detailVC.entryController = entryController
            detailVC.entries = entry
        
    }
    }
    


}
