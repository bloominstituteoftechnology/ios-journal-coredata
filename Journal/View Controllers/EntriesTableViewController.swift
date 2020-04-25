//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Chad Parker on 4/22/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    // NOTE! This is not a good, efficient way to do this, as the fetch request
    // will be executed every time the tasks property is accessed. We will
    // learn a better way to do this later.

    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        cell.entry = entries[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            CoreDataStack.shared.mainContext.delete(entry)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error deleting object: \(error)")
            }
            //entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
