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

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        let entry = fetchedResultsController.object(at: indexPath)
        cell.entry = entry
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil}
        return sectionInfo.name.capitalized
    }
    
    // MARK: - NSFetchedResultsControllerDelegate functions
    // Will Change Content Begin
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Change update delegate functions
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
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("This functionality has not been implemented yet.")
        }
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
    
    // Did Change End
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    // MARK: - Delete function
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete this object
           //
            let entry = fetchedResultsController.object(at: indexPath)
            // Delete the row from the data source
            entryController.delete(delete: entry)
        } 
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? EntryDetailViewController,
                let tappedRow = tableView.indexPathForSelectedRow else { return }
        detailVC.entry = fetchedResultsController.object(at: tappedRow)
    }
        

    // MARK: - NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending :true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        try!frc.performFetch()
        return frc
    }()
    

    // MARK: - Properties
    let entryController = EntryController()

}
