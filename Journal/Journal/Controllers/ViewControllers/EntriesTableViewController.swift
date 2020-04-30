//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Lambda_School_loaner_226 on 4/28/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    var createEntryController = CreateEntryViewController()
    
    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        
        do {
            let fetchedEntry = try context.fetch(fetchRequest)
            return fetchedEntry
        } catch {
            NSLog("Error fetching entry: \(error)")
            return []
        }
    }
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell()}
        
        cell.entry = entries[indexPath.row]
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
                tableView.reloadData()
            } catch {
                context.reset()
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
}
