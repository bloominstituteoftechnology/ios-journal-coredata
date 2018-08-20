//
//  EntriesTableViewController.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/20/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController
{
    let entryController = EntryController()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        let entry = entryController.entries[indexPath.row]
        cell.entry = entry

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry: entry)
            tableView.reloadData()
            
        }
    }
    
    // MARK: - Navigation
    //ShowUpdateView, ShowAddView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowAddView"
        {
            let addDetailView = segue.destination as! EntryDetailViewController
            addDetailView.entryController = entryController
            
        }
        else if segue.identifier == "ShowUpdateView"
        {
            let updateDetailView = segue.destination as! EntryDetailViewController
            updateDetailView.entryController = entryController
            if let indexPath = tableView.indexPathForSelectedRow
            {
                updateDetailView.entry = entryController.entries[indexPath.row]
            }
        }
    }
    

}
