//
//  EntriesTableViewController.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/21/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    //Properties
    let entryController = EntryController()
    
    lazy var fetchedResultsControler: NSFetchedResultsController<Entry> = {
        var fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moodDescriptor = NSSortDescriptor(key: EntryProperties.mood.rawValue, ascending: true)
        let titleDescriptor = NSSortDescriptor(key: EntryProperties.title.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [moodDescriptor, titleDescriptor]
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: EntryProperties.mood.rawValue, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsControler.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsControler.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        let entry = fetchedResultsControler.object(at: indexPath)
        cell.entry = entry
        cell.updateViews()
        return cell
    }
    
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsControler.object(at: indexPath)
            entryController.delete(entry: entry)

        }    
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellDetailSegue" {
            let detailVC = segue.destination as! EntryDetailViewController
            guard let selectedEntryPath = tableView.indexPathForSelectedRow else {return print("Selected row couldnt be found")}
            let entry = fetchedResultsControler.object(at: selectedEntryPath)
            detailVC.entryController = entryController
            detailVC.entry = entry
        } else {
            let detailVC = segue.destination as! EntryDetailViewController
            detailVC.entryController = entryController
        }
    }
    
    
}

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
    
}
