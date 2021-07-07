//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    //MARK: Properties
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "mood", ascending: false),
        NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        cell.entry = fetchedResultsController.object(at: indexPath)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name
    }

    
    // Delete Row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.deleteEntry(entry)
           
        } else if editingStyle == .insert {
            entryController.updateEntry(entryController.entries[indexPath.row], newTitle: entryController.entries[indexPath.row].title ?? "", newbodyText: entryController.entries[indexPath.row].bodyText ?? "", updatedMood: entryController.entries[indexPath.row].mood ?? "")
            
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let detailVC = segue.destination as? EntryDetailViewController else { return }
        
        
        if segue.identifier == "ShowJournalDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.entry = fetchedResultsController.object(at: indexPath)
            detailVC.entryController = entryController
        } else if segue.identifier == "ShowAddEntrySegue" {
            detailVC.entryController = entryController
        }
    }
    
}

//MARK: - Delegate

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
     func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
          //we are going to change the data
          tableView.beginUpdates()
      }
      
      func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
          tableView.endUpdates()
      }
      //sections change. insert, update,
      func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
          switch type {
          case .insert:
              tableView.insertSections(IndexSet(integer: sectionIndex),  with: .automatic)
          case .delete:
              tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
          default:
              break
          }
      }
      //legacy code objc
      //optionals becuase optionals came move
      func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
          switch type {
          case .insert:
              guard let newIndexPath = newIndexPath else { return }
              //.automatic animations
              tableView.insertRows(at: [newIndexPath], with: .automatic)
          case .update:
              guard let indexPath = indexPath else { return }
              tableView.reloadRows(at: [indexPath], with: .automatic)
          case .move:
              guard let oldIndexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
              //delete in old indexpath and insert in new indexpath
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
