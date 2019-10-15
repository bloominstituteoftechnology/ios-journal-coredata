//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by brian vilchez on 10/15/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

enum SegueIdentifier: String {
    case AddEntry
    case EntryDetail
}

enum TableViewCell: String {
    case EntryCell
}

class EntriesTableViewController: UITableViewController {

    //MARK: - properties
    var entryController = EntryController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.EntryCell.rawValue, for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        let entry = entryController.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.entry = entry
        return cell
    }



    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        switch segue.identifier {
        case SegueIdentifier.AddEntry.rawValue:
            guard let addEntryVC = segue.destination as? EntryDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else {return}
                  let entry = entryController.entries[indexPath.row]
            addEntryVC.entry = entry
            addEntryVC.entryController = entryController
        case SegueIdentifier.EntryDetail.rawValue:
            guard let detailEntryVC = segue.destination as? EntryDetailViewController,
                 let indexPath = tableView.indexPathForSelectedRow else {return}
                 let entry = entryController.entries[indexPath.row]
            detailEntryVC.entry = entry
            detailEntryVC.entryController = entryController
        default: return
        }
    }


}
