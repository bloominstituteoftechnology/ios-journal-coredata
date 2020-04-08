//
//  EntriesTableViewController.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/21/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    //Properties
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        var fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moodDescriptor = NSSortDescriptor(key: EntryProperties.mood.rawValue, ascending: true)
        let titleDescriptor = NSSortDescriptor(key: EntryProperties.title.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [moodDescriptor, titleDescriptor]
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: EntryProperties.mood.rawValue, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}


// MARK: - Table view data source
extension EntriesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
        cell.updateViews()
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.delete(entry: entry)

        }    
    }
    //Headers
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        
        return sectionInfo.name.capitalized
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 15))
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: 50, height: 30))
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        headerView.backgroundColor = .lightGray
        label.text = sectionInfo.name.capitalized
        headerView.addSubview(label)
        
        return headerView
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellDetailSegue" {
            let detailVC = segue.destination as! EntryDetailViewController
            guard let selectedEntryPath = tableView.indexPathForSelectedRow else {return print("Selected row couldnt be found")}
            let entry = fetchedResultsController.object(at: selectedEntryPath)
            detailVC.entryController = entryController
            detailVC.entry = entry
        } else {
            let detailVC = segue.destination as! EntryDetailViewController
            detailVC.entryController = entryController
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
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        case .move:
            guard let newIndexPath = newIndexPath else { return }
            guard let indexPath = indexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
            
        @unknown default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let sections = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sections, with: .fade)
            
        case .delete:
            tableView.deleteSections(sections, with: .fade)
            
        default:
            break
        }
    }
}



