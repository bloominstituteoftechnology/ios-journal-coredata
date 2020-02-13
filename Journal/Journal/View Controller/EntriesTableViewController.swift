//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    //MARK: Properties
    let entryController = EntryController()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
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
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
       let entry = entryController.entries[indexPath.row]
        cell.entryTitleLabel.text = entry.title
        cell.bodyTextLabel.text = entry.bodyText
        cell.timeStamp.text = "\(dateFormatter.string(from: entry.timestamp!))"

        

        return cell
    }
 

  

   
    // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //fetch getting called again. Very enfficient
            let entry = entryController.entries[indexPath.row]
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
        if segue.identifier == "ShowAddEntrySegue" {
            if let addVC = segue.destination as? EntryDetailViewController {
                addVC.entryController = entryController
            } else if segue.identifier == "ShowEntryDetailSegue"{
                if let detailVC = segue.destination as? EntryDetailViewController,
                    let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.entryController = entryController
                    detailVC.entry = entryController.entries[indexPath.row]
                }
               
            }
        }
    
    }
 

}
