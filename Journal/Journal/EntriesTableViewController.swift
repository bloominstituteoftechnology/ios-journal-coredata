//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/16/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry

        

        return cell
    }
    

    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
        default:
            break
        }
    }
    



    
    // MARK: - Navigation

 // //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowCreateJournalEntrySegue":
            guard let entryDetailVC = segue.destination as? EntryDetialViewController else { return }
            entryDetailVC.entryController = entryController
            
        case "ShowJournalDetial":
            guard let entryDetailVC = segue.destination as? EntryDetialViewController, let indexpath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexpath.row]
            entryDetailVC.entry = entry
            entryDetailVC.entryController = entryController
        default:
            break
        }
    }
    

}
