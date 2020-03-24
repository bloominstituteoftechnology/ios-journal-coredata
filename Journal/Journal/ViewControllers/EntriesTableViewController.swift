//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        
        let item = entryController.entries[indexPath.row]
        
             cell.entry = item

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = entryController.entries[indexPath.row]
            entryController.delete(entry: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEntry" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? EntryDetailViewController {
                targetController.entryController = entryController
            }
        }

        if segue.identifier == "modifyEntry" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? EntryDetailViewController {
                targetController.entryController = entryController
                if let indexPath = tableView.indexPathForSelectedRow {
                    targetController.entry = entryController.entries[indexPath.row]
                }
            }
        }
    }
    

}
