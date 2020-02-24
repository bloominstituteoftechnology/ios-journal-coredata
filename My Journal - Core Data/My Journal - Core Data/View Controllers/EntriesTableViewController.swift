//
//  EntriesTableViewController.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController
{

    private let entryController = EntryController()
    
    
    
    
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Helper.cellID, for: indexPath) as? EntryTableViewCell else { return UITableViewCell()}
        cell.entry = entryController.entries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 
// MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case Helper.addSegue:
                guard let destVC = segue.destination as? EntryDetailViewController else { return }
                destVC.entryController = entryController
            case Helper.cellSegue:
                guard let destVC = segue.destination as? EntryDetailViewController else { return }
                
                if let index = tableView.indexPathForSelectedRow {
                    destVC.entry = entryController.entries[index.row]
                    destVC.entryController = entryController
            }
            
                
            default:
            break
        }
    }
}
