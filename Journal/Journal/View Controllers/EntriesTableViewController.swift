//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Paul Yi on 2/18/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        // Create a fetch request from the Entry object
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        // Create a sort descriptor that will sort entries based on their timestamp
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        // Create a constant that references your core data stack's mainContext
        let moc = CoreDataStack.shared.mainContext
        // Create an constant and initialize an NSFetchedResultsController using the fetch request and managed object context.
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        // Set this view controller class as the delegate of the fetched results controller
        frc.delegate = self
        // Performt the fetch request using the fetched results controller
        try! frc.performFetch()
        // Return the fetched results controller
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        let entry = entryController.entries[indexPath.row]
        cell.entry = entry

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.reloadData()
        }    
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.deleteRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? EntryDetailViewController else { return }
        detailVC.entryController = entryController
        
        if segue.identifier == "ViewExistingEntry" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            detailVC.entry = entry
        }
    }

}
