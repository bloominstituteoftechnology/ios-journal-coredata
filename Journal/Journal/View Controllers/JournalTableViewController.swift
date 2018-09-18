//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Farhan on 9/17/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    let journalController = JournalController()

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
        return journalController.journal.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? JournalTableViewCell else {return UITableViewCell()}

        cell.entry = journalController.journal[indexPath.row]
        // Configure the cell...

        return cell
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
            let journal = journalController.journal[indexPath.row]
            journalController.deleteJournalEntry(entry: journal)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ViewEntry"{
            
            guard let destVC = segue.destination as? JournalDetailViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            destVC.journalController = journalController
            
            destVC.entry = journalController.journal[indexPath.row]
            
        } else if segue.identifier == "AddEntry"{
            
            guard let destVC = segue.destination as? JournalDetailViewController else {return}
            destVC.journalController = journalController
            
        }
        
        
    }
    

}
