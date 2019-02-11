//
//  EntriesTableViewController.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entryController.entries.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryTableViewCell

        let entry = entryController.entries[indexPath.row]
        
        cell.entry = entry

        return cell
    }
   

   
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = entryController.entries[indexPath.row]
            
            entryController.delete(entry: entry)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createEntry" {
            let destinationVC = segue.destination as? EntryDetailViewController
            destinationVC?.entryController = entryController
        } else if segue.identifier == "showDetailVC" {
            let destinationVC = segue.destination as? EntryDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let entry = entryController.entries[indexPath.row]
            destinationVC?.entry = entry
            destinationVC?.entryController = entryController
        }
    }
    

}
