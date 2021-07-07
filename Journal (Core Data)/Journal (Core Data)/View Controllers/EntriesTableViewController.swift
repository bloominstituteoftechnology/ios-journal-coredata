//
//  EntriesTableViewController.swift
//  Journal (Core Data)
//
//  Created by Michael on 1/27/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    let entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell()}

        // Configure the cell...
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.deleteEntry(for: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            entryController.updateEntry(for: entryController.entries[indexPath.row], title: entryController.entries[indexPath.row].title ?? "", bodyText: entryController.entries[indexPath.row].bodyText ?? "")
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateEntrySegue" {
            guard let addEntryVC = segue.destination as? EntryDetailViewController else { return }
            addEntryVC.entryController = entryController
        } else if segue.identifier == "JournalDetailSegue" {
            guard let editEntryVC = segue.destination as? EntryDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            editEntryVC.entryController = entryController
            editEntryVC.entry = entryController.entries[indexPath.row]
        }
    }
}
