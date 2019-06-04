//
//  EntriesTableViewController.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit



class EntriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return entryController.entries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        // Configure the cell...
        cell.entry = entryController.entries[indexPath.row]


        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entryController.deleteEntry(entry: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEntry" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }

            detailVC.entry = entryController.entries[indexPath.row]
            detailVC.entryController = entryController
        }else {
            if segue.identifier == "AddEntry" {
                guard let detailVC = segue.destination as? EntryDetailViewController else { return }
                detailVC.entryController = entryController
            }
        }
    }
    var entryController = EntryController()
    var entry: Entry?
}
