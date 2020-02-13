//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Eoin Lavery on 13/02/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit
import CoreData

class JournalTableViewController: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //MARK: Properties
    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        }  catch {
           print("Error retrieving data from persistent store: \(error)")
            return []
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? JournalTableViewCell else { return UITableViewCell() }
        
        let entry = entries[indexPath.row]
        cell.entry = entry
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                moc.reset()
                print("Error trying to delete row: \(error)")
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntryShowSegue" {
            //Add Logic if required when clicking the + button on JournalTableViewController
        } else if segue.identifier == "ViewEntryShowSegue" {
            guard let detailVC = segue.destination as? JournalDetailViewController,
                let selectedIndexPath = tableView.indexPathForSelectedRow?.row else { return }
            
            if (selectedIndexPath - 1) <= entries.count {
                detailVC.entry = entries[selectedIndexPath]
            }
        }
    }

}
