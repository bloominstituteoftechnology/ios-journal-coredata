//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Jarren Campos on 4/22/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let fetchEntries = try context.fetch(fetchRequest)
            
            return fetchEntries
        } catch {
            NSLog("Error fetching")
            return []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
        let index = indexPath.row
        cell.entry = entries[index]

        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                
                let entry = entries[indexPath.row]
                let context = CoreDataStack.shared.mainContext
                
                context.delete(entry)
                
                do {
                    try context.save()
                }catch {
                    NSLog("Error saving context after deleting Task: \(error)")
                    context.reset()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
    }



}
