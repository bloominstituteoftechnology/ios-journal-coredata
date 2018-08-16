//
//  EntriesTableViewController.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let entryController =  EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        // Create fetchRequest from Entry object
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // Sort the entries based on timestamp
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: true),
                                        NSSortDescriptor(key: "timestamp", ascending: true)]
        
        // Get CoreDataStack's mainContext
        let moc = CoreDataStack.shared.mainContext
        
        // Initialize NSFetchedResultsController
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        // Set this VC as frc's delegate
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error fetching: \(error)")
        }
        return frc
    }()

    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        tableView.reloadData()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        // NSFetchedResultsChangeType has four types: insert, delete, move, update
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
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            //            tableView.moveRow(at: oldIndexPath, to:  newIndexPath)
            // Doesn't work any more?
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name.capitalized
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        // Set cell's entry to the entry at the specific indexPath
//        cell.entry = entryController.entries[indexPath.row]
        cell.entry = fetchedResultsController.object(at: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Get the entry at the cell we want to delete
//            let entry = entryController.entries[indexPath.row]
            let entry = fetchedResultsController.object(at: indexPath)
            
            entryController.delete(entry: entry)
            
//            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowEntryDetail" {
//            let detailVC = segue.destination as! EntryDetailViewController
//            detailVC.entryController = entryController
//
//            // Get indexPath of selected cell
//            if let indexPath = tableView.indexPathForSelectedRow?.row {
//                // Setting the entry at that indexPath to the detailVC's entry property
//                detailVC.entry = entryController.entries[indexPath]
//            }
//        } else if segue.identifier == "ShowAddEntry" {
//            let detailVC = segue.destination as! EntryDetailViewController
//            detailVC.entryController = entryController
//        }

        if let detailVC = segue.destination as? EntryDetailViewController {
            detailVC.entryController = entryController
            
            if segue.identifier == "ShowEntryDetail" {
                if let indexPath = tableView.indexPathForSelectedRow{
                    // Setting the entry at that indexPath to the detailVC's entry property
//                    detailVC.entry = entryController.entries[indexPath.row]
                    detailVC.entry = fetchedResultsController.object(at: indexPath)
                }
            }
        }
    }
}
