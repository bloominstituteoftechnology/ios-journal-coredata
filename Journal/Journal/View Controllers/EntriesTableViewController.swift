//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Mark Poggi on 4/20/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    // MARK: - Tableview Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0  // numberOfObjects works with collection views and table views.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        
        return sectionInfo.name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {
            fatalError("Can't dequeue cell of type \(EntryTableViewCell.reuseIdentifier)")
        }
        
        // Configure the cell...
        
        cell.entry = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.deleteEntryFromServer(entry: entry)
            
            CoreDataStack.shared.mainContext.delete(entry)  // This marks it for deletion, but doesn't actually delete it until you do a commit AKA a save in CoreData terminology.
            do {
                try CoreDataStack.shared.mainContext.save()  // saves the current state.
                //  tableView.deleteRows(at: [indexPath], with: .fade)  // this can be removed because we added the delegate.
                
            } catch {
                CoreDataStack.shared.mainContext.reset()  // returns tasks to base state if delete is unsuccessful.  We avoid a "half" delete by doing this.
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            if let detailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entry = fetchedResultsController.object(at: indexPath)
            }
        } else if segue.identifier == "AddEntryModalSegue" {
            if let navC = segue.destination as? UINavigationController,
                let createEntryVC = navC.navigationController as? CreateEntryViewController {
                createEntryVC.entryController = entryController
            }
        }
    }
}

// MARK: - Extensions

extension EntriesTableViewController: NSFetchedResultsControllerDelegate { // this code below is very boiler plate.  Change from tableview to containerview if you're working with containers.
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
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
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
