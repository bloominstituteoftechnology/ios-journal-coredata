//
//  EntriesTableViewController.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let entryController = EntryController()
    

    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { fatalError() }
        
        // Assign entry to cell
        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.delete(at: entryController.entries[indexPath.row])
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateEntryShowSegue" {
            guard let entryDetailVC = segue.destination as? EntryDetailViewController else { return }
            entryDetailVC.entryController = self.entryController
        } else if segue.identifier == "EditEntryShowSegue" {
            guard let entryDetailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            entryDetailVC.entryController = self.entryController
            entryDetailVC.entry = entryController.entries[indexPath.row]
        }
    }

}
