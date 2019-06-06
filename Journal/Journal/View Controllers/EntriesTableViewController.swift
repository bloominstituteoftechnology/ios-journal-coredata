//
//  EntriesTableViewController.swift
//  Journal - Day 2
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: -View states
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    
    // MARK: - Delete function
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete this object
            entryController.delete(delete: entryController.entries[indexPath.row])
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let detailVC = segue.destination as? EntryDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
                detailVC.entry = entryController.entries[indexPath.row]
    }
        

    // MARK: - NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending :true),
                                              NSSortDescriptor(key: "title", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        try!frc.performFetch()
        return frc
    }()
    
    
    
    
    
    
    
    
    // MARK: - Properties
    let entryController = EntryController()

}
