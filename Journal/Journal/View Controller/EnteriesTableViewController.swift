//
//  EnteriesTableViewController.swift
//  Journal
//
//  Created by Enzo Jimenez-Soto on 5/18/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    
    var entries: [Entry]  {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
               let context = CoreDataStack.shared.mainContext
               do {
                   return try context.fetch(fetchRequest)
               } catch {
                   NSLog("Error fetching tasks: \(error)")
                   return []
               }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.reuseIdentifier, for: indexPath) as? EntryTableViewCell else {
        fatalError("Can't dequeue cell of type \(EntryTableViewCell.reuseIdentifier)")
        }
        cell.entry = entries[indexPath.row]

        return cell
    }
    


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
         
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
         
        }
    }
    


}
