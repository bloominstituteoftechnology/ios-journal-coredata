//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Mark Poggi on 4/20/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit
import CoreData


class EntriesTableViewController: UITableViewController {
    
    let reuseIdentifier = "EntryCell"
    
    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? EntryTableViewCell else {
            fatalError("Can't dequeue cell of type \(EntryTableViewCell.self)")
          }
          
          // Configure the cell...
          
          cell.entry = entries[indexPath.row]
          return cell
      }


    // TODO: Add support for deleting tasks
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         // This allows the table view to be notified of changes to the data model.
         
         tableView.reloadData()
     }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        guard let controller = segue.description as? CreateEntryViewController,
        let indexPath = tableView.indexPathForSelectedRow else { return }
        
        
        
        // Pass the selected object to the new view controller.

    }
 

}
