//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
//    var entries: [Entry] {
//
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//        let context = CoreDataStack.shared.mainContext
//
//        do {
//            let fetchedTasks = try context.fetch(fetchRequest)
//
//            return fetchedTasks
//        } catch {
//            NSLog("Error fetching tasks: \(error)")
//            return []
//        }
//    }
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "mood", ascending: true),
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    
    var dateFormatter: DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
        let entry = fetchedResultsController.object(at: indexPath)
        
        cell.entry = entry
        
        return cell
    }
    
    
    private func entryFor(indexPath: IndexPath) -> Entry {
        var journalEntry: Entry?
        if indexPath.section == 0 {
            journalEntry = fetchedResultsController.object(at: indexPath)
        } else if indexPath.section == 1 {
            journalEntry = fetchedResultsController.object(at: indexPath)
        } else if indexPath.section == 2 {
            journalEntry = fetchedResultsController.object(at: indexPath)
        }
        return journalEntry!
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = fetchedResultsController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            
            context.delete(entry)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saviing context after deleting Entry: \(error)")
                context.reset()
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard  let sectionInfo = fetchedResultsController.sections?[section] else {
            return nil
        }
        return sectionInfo.name
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EntryDetailSegue" {
            if let editVC = segue.destination as? EntryDetailViewController {
                if let indextPath = tableView.indexPathForSelectedRow {
                editVC.entry = entryFor(indexPath: indextPath)
             //       editVC.delegate = self
                }
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

extension EntriesTableViewController: EntryDelegate {
    func entryWasCreated(_ entry: Entry) {
       let x = 1
    }
}
