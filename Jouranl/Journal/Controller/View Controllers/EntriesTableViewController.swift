//
//  EntriesTableViewController.swift
//  Jouranl
//
//  Created by Joshua Rutkowski on 2/12/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    // MARK: - Properties
    let entryController = EntryController()
    var dateFormatter: DateFormatter {
         let formatter = DateFormatter()
         formatter.dateStyle = .short
         formatter.timeStyle = .short
         return formatter
     }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         tableView.reloadData()
     }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return entryController.entries.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}

         let entry = entryController.entries[indexPath.row]
         cell.titleLabel.text = entry.title
         cell.bodyLabel.text = entry.bodyText
         cell.timestampLabel.text = "\(dateFormatter.string(from: entry.timestamp!))"

         return cell

    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entryController.delete(entry: entryController.entries[indexPath.row])
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

         if segue.identifier == "ShowJournalSegue" {
             if let detailVC = segue.destination as?
             EntryDetailViewController,
                 let indexPath = tableView.indexPathForSelectedRow {

                 detailVC.entryController = entryController
                 detailVC.entry = entryController.entries[indexPath.row]
             }
         } else if segue.identifier == "AddJournalSegue" {
             if let detailVC = segue.destination as?
                 EntryDetailViewController {
                 detailVC.entryController = entryController
             }
         }
     }

}
