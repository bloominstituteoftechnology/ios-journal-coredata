//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let entryController = EntryController()
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entryTableViewCell = cell as! EntryTableViewCell
        entryTableViewCell.entry = entryController.entries[indexPath.row]
        
        return entryTableViewCell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let entryDetailViewController = segue.destination as? EntryDetailViewController else { return }
        
        if segue.identifier == "ShowEntryDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            entryDetailViewController.entry = entry
            entryDetailViewController.entryController = entryController
            
        } else if segue.identifier == "ShowEntryCreate" {
            entryDetailViewController.entryController = entryController
        }
    }

}
