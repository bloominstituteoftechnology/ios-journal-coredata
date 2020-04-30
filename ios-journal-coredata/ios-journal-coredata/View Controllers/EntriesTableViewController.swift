//
//  EntriesTableViewController.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            return tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            return tableView.deleteSections([sectionIndex], with: .fade)
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
            guard let newIndexPath = newIndexPath, let oldIndexPath = indexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        cell.entry = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            
            entryController.deleteEntryFromServer(entry: entry)
            
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
            } catch {
                moc.reset()
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateEntry" {
            let createVC = segue.destination as! EntryDetailViewController
            createVC.entryController = entryController
            
        } else if segue.identifier == "ShowEntryDetail" {
            let detailVC = segue.destination as! EntryDetailViewController
            detailVC.entryController = entryController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entry = fetchedResultsController.object(at: indexPath)
            }
            
        }
    }
    
    // MARK: - Properties
    
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        // The first sortDescriptor must have the same key as the sectionNameKeyPath in the NSFetchedResultsController!
        let sortDescriptor = [NSSortDescriptor(key: "mood", ascending: true), NSSortDescriptor(key: "timestamp", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptor
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()

}
