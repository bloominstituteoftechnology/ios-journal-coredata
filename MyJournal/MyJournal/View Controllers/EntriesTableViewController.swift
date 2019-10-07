//
//  EntriesTableViewController.swift
//  MyJournal
//
//  Created by Eoin Lavery on 02/10/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    //MARK: - PROPERTIES
    let entriesController = EntriesController()
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "mood", ascending: true),
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        try! frc.performFetch()
        return frc
    }()
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - TABLE VIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section].name else { return nil }
        return sectionInfo
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        cell.entry = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
            } catch {
                moc.reset()
                print("Error deleting Entry from CoreData Persistent Store: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntryShowSegue" {
            if let addEntryVC = segue.destination as? EntryDetailViewController {
                addEntryVC.entriesController = entriesController
            }
        } else if segue.identifier == "DetailEntryShowSegue" {
            if let detailVC = segue.destination as? EntryDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entriesController = entriesController
                detailVC.entry = fetchedResultsController.object(at: indexPath)
            }
        }
    }

}

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           tableView.beginUpdates()
       }
    
       func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           tableView.endUpdates()
       }
       
       func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
           
           switch type {
           case .insert:
               tableView.insertSections(IndexSet(integer: sectionIndex), with: .right)
           case .delete:
               tableView.deleteSections(IndexSet(integer: sectionIndex), with: .left)
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
               tableView.deleteRows(at: [indexPath], with: .left)
           case .move:
               guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
               tableView.moveRow(at: oldIndexPath, to: newIndexPath)
           case .update:
               guard let indexPath = indexPath else { return }
               tableView.reloadRows(at: [indexPath], with: .automatic)
           @unknown default:
               break
           }
           
       }
    
}
