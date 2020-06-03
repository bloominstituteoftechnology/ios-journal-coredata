//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Clayton Watkins on 6/3/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    //MARK: - Properties
    var entries: [Entry] {
        let fetchRequest : NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do{
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    //MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell()}
        
        cell.entry = entries[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            do{
                try moc.save()
                tableView.reloadData()
            } catch {
                moc.reset()
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    
}
