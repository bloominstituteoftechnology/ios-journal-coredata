//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Chris Dobek on 4/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

   // MARK: - Properties
    
   lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
          let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
          fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: true),
                                          NSSortDescriptor(key: "title", ascending: true)]
          let context = CoreDataStack.shared.mainContext
          let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "mood", cacheName: nil)
          frc.delegate = self
          try! frc.performFetch()
          return frc
      }()

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           return fetchedResultsController.sections?.count ?? 1
       }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        
        return sectionInfo.name.capitalized
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.reuseIdentifier, for: indexPath) as? EntryTableViewCell else {
            fatalError("Could not dequeue cell as \(EntryTableViewCell.reuseIdentifier)")
        }

       cell.entry = fetchedResultsController.object(at: indexPath)
        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
                    CoreDataStack.shared.mainContext.delete(entry)
                    do {
                        try CoreDataStack.shared.mainContext.save()
                    } catch {
                        CoreDataStack.shared.mainContext.reset()
                        NSLog("Error saving managed object context: \(error)")
                    }
                }
            }

   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEntryDetailSegue" {
                   if let detailVC = segue.destination as? EntryDetailViewController,
                       let indexPath = tableView.indexPathForSelectedRow {
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

