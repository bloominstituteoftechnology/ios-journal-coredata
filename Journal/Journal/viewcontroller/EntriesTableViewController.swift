//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Vincent Hoang on 5/18/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController{
    let context = CoreDataStack.shared.mainContext
    
    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "entryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EntryTableViewCell else {
            NSLog("Dequeued cell is not of type EntryTableViewCell")
            
            let errorCell = EntryTableViewCell()
            errorCell.entry = Entry(title: "Error", bodyText: "", timeStamp: Date(), mood: Mood.neutral)
            
            return errorCell
        }
        
        cell.entry = entries[indexPath.row]
        
        return cell
    }

}
