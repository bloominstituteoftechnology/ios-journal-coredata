//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/22/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    //MARK: - Properties -
    
    var entries: [Entry] {
        
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let fetchedEntries = try context.fetch(fetchRequest)
            return fetchedEntries
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    // MARK: - Methods -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        cell.entry = entries[indexPath.row]
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let entry = entries[indexPath.row]
            let context = CoreDataStack.shared.mainContext
            
            context.delete(entry)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving context after deleting Task: \(error)")
                context.reset()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
} //End of class
