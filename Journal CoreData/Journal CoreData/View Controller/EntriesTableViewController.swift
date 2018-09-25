//
//  EntriesTableViewController.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import UIKit
import CoreData

let moc = CoreDataStack.shared.mainContext

class EntriesTableViewController: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        let entry = entries[indexPath.row]
        cell.entry = entry
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             let entry = entries[indexPath.row]
            moc.delete(entry)
            do{
                try moc.save()
                //tableView.reloadData()
            }
            catch{
                moc.reset()
                NSLog("Error saving managed object context\(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEntry"{
            guard let _ = segue.destination as? EntryDetailViewController else {return}
        }else if segue.identifier == "showEntry"{
            guard let detailVc = segue.destination as? EntryDetailViewController,
                let index = tableView.indexPathForSelectedRow else {return}
            detailVc.entry = entries[index.row]
        }
    }



}
