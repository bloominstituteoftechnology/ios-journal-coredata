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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellEnty", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
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
                tableView.reloadData()
            }
            catch{
                moc.reset()
                NSLog("Error savig managed object context\(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    var entries: [Entry]{
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do{
            return try moc.fetch(fetchRequest)
        }catch{
            NSLog( "Error occured while trying to fetch data from Persistence Store: \(error)")
            return []
        }
    }


}
