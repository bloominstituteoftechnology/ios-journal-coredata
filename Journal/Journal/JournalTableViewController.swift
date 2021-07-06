//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Kobe McKee on 6/3/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {

    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        cell.entry = entryController.entries[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.deleteEntry(entry: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewEntrySegue" {
            let destinationVC = segue.destination as! EntryDetailViewController
            destinationVC.entryController = entryController
        } else if segue.identifier == "EntryDetailSegue" {
            let destinationVC = segue.destination as! EntryDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.entry = entryController.entries[indexPath.row]
            }
            destinationVC.entryController = entryController
        }
    }
    

}
