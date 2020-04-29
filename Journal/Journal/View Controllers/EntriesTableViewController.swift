//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/22/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    //MARK: - Properties -
    
    var entries: [Entry] {
        
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let fetchedEntries = try context.fetch(fetchRequest)
            return fetchedEntries
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: true),
                                        NSSortDescriptor(key: "timestamp", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    // MARK: - Methods -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {
            fatalError("Can't dequeue cell of type EntryCell")
        }
        
        cell.entry = fetchedResultsController.object(at: indexPath)
        return cell
        
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "ShowTaskDetail" {
    //            if let detailVC = segue.destination as? TaskDetailViewController,
    //                let indexPath = tableView.indexPathForSelectedRow {
    //                detailVC.task = fetchedResultsController.object(at: indexPath)
    //                detailVC.taskController = taskController
    //            }
    //        } else if segue.identifier == "CreateTaskModalSegue" {
    //            if let navC = segue.destination as? UINavigationController,
    //                let createTaskVC = navC.viewControllers.first as? CreateTaskViewController {
    //                createTaskVC.taskController = taskController
    //            }
    //        }
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EntryDetailSegue" {
            guard let index = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? EntryDetailViewController else { return }
            detailVC.entry = fetchedResultsController.object(at: index)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let entry = fetchedResultsController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            context.delete(entry)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving context after deleting Task: \(error)")
                context.reset()
            }
        }
    }
    
} //End of class

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
    
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
