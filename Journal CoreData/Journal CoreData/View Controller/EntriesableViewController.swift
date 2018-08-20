//
//  EntriesableViewController.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    let moc = CoreDataStack.shared.mainContext
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
  



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        return cell
    }
    




    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDetail" {
            let detailVC = segue.destination as! EntryDetailViewController
            detailVC.entryController = entryController
        } else if segue.identifier == "showDetail" {
            let detailC = segue.destination as! EntryDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            detailC.entry = entryController.entries[indexPath.row]
            detailC.entryController = entryController
        }
       
    }


    let entryController = EntryController()
}
