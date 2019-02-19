//
//  EntryTableViewController.swift
//  Core Data Journal
//
//  Created by Jaspal on 2/19/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    @IBAction func add(_ sender: Any) {
        // Not used since we'll be handling things via the segues.
    }
    
    let entryController = EntryController()
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        // Remember to cast the call as EntryTableViewCell,
        // then pass an Entry to the cell's entry property [...]
        let entryTableViewCell = cell as! EntryTableViewCell
        entryTableViewCell.entry = entryController.entries[indexPath.row]
        
        return entryTableViewCell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

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
        guard let entryDetailViewController = segue.destination as? EntryDetailViewController else { return }
        
        if segue.identifier == "ShowEntryDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            entryDetailViewController.entry = entry
            entryDetailViewController.entryController = entryController
            
        } else if segue.identifier == "ShowCreateEntry" {
            entryDetailViewController.entryController = entryController
        }
    }

}
