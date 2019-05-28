//
//  EntriesTableViewController.swift
//  Journal-CoreData
//
//  Created by Sameera Roussi on 5/27/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let entryController = EntryController()
    
    
    // MARK: - View States

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload the data to get the record count
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntriesCell", for: indexPath) as! EntryTableViewCell

        // Read the entry at this index number
        let thisEntry = entryController.entries[indexPath.row]
        cell.entry = thisEntry

        return cell
    }

    // MARK: - Actions

    @IBAction func addBarButtonTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "DetailScene") as? EntryDetailViewController
            else { print("Could not find the Entry Detail VC"); return}
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    
    
    // Mark: - Delete Edit
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let thisEntry = entryController.entries[indexPath.row]
            entryController.delete(delete: thisEntry)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)

        }    
    }
    

    // MARK: - Navigation
    
    // DisplayEntrySegue

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Only one destination
        guard let destination = segue.destination as? EntryDetailViewController else { return }
        destination.entryController = entryController
        
        // Segue to display an entry
        if segue.identifier == "DisplayEntrySegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            //let entry = entryController.entries[indexPath.row]
            // Pass the EntryController and the Entry to be displayed / Updated
            destination.entry = entryController.entries[indexPath.row]
            
            
        } //else {
            // There's nothing to pass, just go!

        //}
    
    }


}
