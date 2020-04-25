//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    var entries: [Entry] {
      //Fetch request to fetch Tasks specifically
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        //context you want to fetch the model object into
        let context = CoreDataStack.shared.mainContext
        
        do {
            let fetchedEntries = try context.fetch(fetchRequest)
            return fetchedEntries
            
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {
            fatalError()
        }

        // Configure the cell...
        let entry = entries[indexPath.row]
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let entry = entries[indexPath.row]
            let context = CoreDataStack.shared.mainContext
            
            context.delete(entry)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving context after deleting Entry: \(error)")
                context.reset()
            }
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }





