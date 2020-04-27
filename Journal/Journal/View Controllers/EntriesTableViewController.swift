//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/22/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    var entries: [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let fetchedEntries = try context.fetch(fetchRequest)
            return fetchedEntries
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {
            fatalError("Can't dequeue cell of type \(EntryTableViewCell.reuseIdentifier)")
        }

        cell.entry = entries[indexPath.row]
                
        return cell
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let entry = entries[indexPath.row]
            let context = CoreDataStack.shared.mainContext
            
            context.delete(entry)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving context after deleting entry: \(error)")
                context.reset()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }



}
