//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    var entryController: EntryController?

    /*
    var entries: [Entry] {
      //Fetch request to fetch Tasks specifically
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        //context you want to fetch the model object into
        let context = CoreDataStack.shared.mainContext
        
        do {
            let fetchedEntries = try context.fetch(fetchRequest)
            return fetchedEntries
            
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    */
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
           
           let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
           
           fetchRequest.sortDescriptors = [
               NSSortDescriptor(key: "mood", ascending: true), NSSortDescriptor(key: "timestamp", ascending: true)
           ]
           
           let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: CoreDataStack.shared.mainContext,
                                                sectionNameKeyPath: "mood",
                                                cacheName: nil)
           frc.delegate = self
           
           try! frc.performFetch()
           
           return frc
           
       }()
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {
            fatalError()
        }

        // Configure the cell...
        let entry = fetchedResultsController.object(at: indexPath)
       // let entry = entries[indexPath.row]
       cell.entry = entry
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            let entry = fetchedResultsController.object(at: indexPath)
            //let entry = entries[indexPath.row]
            let context = CoreDataStack.shared.mainContext
            
            context.delete(entry)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving context after deleting Entry: \(error)")
                context.reset()
            }
            
        entryController?.deleteEntryFromServer(entry: entry)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return nil
        }
        
        return sectionInfo.name.capitalized
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
        
        guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? EntryDetailViewController else { return }
      
       let entry = fetchedResultsController.object(at: indexPath)
        destinationVC.entry = entry
        
    }

    }

}

// Mainly to communicate changes to our model objects in Core Data to the view controller to visually display those changes
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




