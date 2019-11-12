//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Rick Wolter on 11/11/19.
//  Copyright © 2019 Richar Wolter. All rights reserved.
//
import CoreData
import UIKit

class EntriesTableViewController: UITableViewController {


    var entries: [Entry] {
           let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
           let moc = CoreDataStack.shared.mainContext
           do {
               return try moc.fetch(fetchRequest)
           } catch {
               print("Error fetching tasks \(error)")
               return []
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           tableView.reloadData()
       }


    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        
        let entry = entries[indexPath.row]
        cell.entry = entry
        
//        cell.entryTitleLabel.text = entry.title
//        cell.entryBodyLabel.text = entry.bodyText
      
        

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
        if editingStyle == .delete {
            
            let entry = entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            do {
                try moc.save()
                tableView.reloadData()
            } catch {
                moc.reset()
                print("Error saving managed object context: \(error)")
            }
        }
    }
    

  
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellDetailSegue" {
            if let detailVC = segue.destination as? EntryDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entry = entries[indexPath.row]
            }
            
        }
    }
    

}
