//
//  EntriesTableViewController.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
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
    
    @IBAction func add(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(entryController.entries.count)
        return entryController.entries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EntryTableViewCell else { fatalError("Unable to dequeue cell") }
       
            cell.entry = entryController.entries[indexPath.row]
        
        return cell
    }
  


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? EntryDetailViewController else { return }

        if segue.identifier == "cell" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            detailVC.entry = entry
            detailVC.entryController = entryController
        } else if segue.identifier == "add" {
            detailVC.entryController = entryController
        }
    }
 
    
    // MARK: - Properties
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
}
