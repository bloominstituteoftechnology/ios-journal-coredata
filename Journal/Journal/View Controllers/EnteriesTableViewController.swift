//
//  EnteriesTableViewController.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class EnteriesTableViewController: UITableViewController {

    var entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EnteryCell", for: indexPath) as? EnteryTableViewCell else { return UITableViewCell() }

        cell.entry = entryController.entries[indexPath.row]

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.delete(entry: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateEntery" {
            let destination = segue.destination as! EnteryDetailViewController

            destination.entryController = entryController
        } else if segue.identifier == "ShowEnteryDetail" {
            let destination = segue.destination as! EnteryDetailViewController

            destination.entryController = entryController

            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.entry = entryController.entries[indexPath.row]
            }
        }
    }


}
