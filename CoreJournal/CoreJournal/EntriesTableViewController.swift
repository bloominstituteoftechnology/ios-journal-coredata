//
//  EntriesTableViewController.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    let entryController = EntryController()
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        
        

        return cell
    }
    

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return}
        
        let entry = entryController.entries[indexPath.row]
        entryController.delete(withEntry: entry)
        tableView.reloadData()
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EntryDetail" {
            guard let cellDetailController = segue.destination as? EntryDetailViewController, let cell = sender as? EntryTableViewCell else { return }
            
            cellDetailController.entryController = entryController
            cellDetailController.entry = cell.entry
            
        } else if segue.identifier == "CreateEntry" {
            guard let addEntryController = segue.destination as? EntryDetailViewController else { return }
            
            addEntryController.entryController = entryController
            
        }
    }
    

}
