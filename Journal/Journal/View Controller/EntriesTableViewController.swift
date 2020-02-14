//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    //MARK: Properties
    let entryController = EntryController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        guard indexPath.row < entryController.entries.count else { return UITableViewCell() }
        
        cell.entry = entryController.entries[indexPath.row]

        return cell


    }
 
   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Delete the row from the data source
              let entry = entryController.entries[indexPath.row]
              entryController.deleteEntry(entry)
              tableView.deleteRows(at: [indexPath], with: .fade)
          } else if editingStyle == .insert {
            entryController.updateEntry(entryController.entries[indexPath.row], newTitle: entryController.entries[indexPath.row].title ?? "", newbodyText: entryController.entries[indexPath.row].bodyText ?? "")
                
          }
      }


        // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        guard let detailVC = segue.destination as? EntryDetailViewController else { return }

        
        if segue.identifier == "ShowJournalDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let index = entryController.entries[indexPath.row]
            detailVC.entry = index
            detailVC.entryController = entryController
        } else if segue.identifier == "ShowAddEntrySegue" {
            detailVC.entryController = entryController
        }
    }
 
}
