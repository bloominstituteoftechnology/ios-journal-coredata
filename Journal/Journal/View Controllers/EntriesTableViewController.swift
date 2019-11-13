//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    // MARK: - Properties
    
    var entryController = EntryController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entryController.tableView = tableView
        tableView.dataSource = entryController
        tableView.delegate = entryController
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewEntryDetailSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
                else {
                    print("Error: failed to cast segue destination as EntryDetailViewController, or failed to get index path for selected row.")
                    return
            }
            
            detailVC.entry = entryController.fetch(entryAt: indexPath)
            detailVC.entryController = entryController
        } else if segue.identifier == "NewEntrySegue" {
            guard let addVC = segue.destination as? EntryDetailViewController
                else {
                    print("Error: failed to cast segue destination as EntryDetailViewController.")
                    return
            }
            addVC.entryController = entryController
        }
    }
}
