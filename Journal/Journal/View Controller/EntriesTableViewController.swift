//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Claudia Contreras on 4/22/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    // MARK: - Properties
    var entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        // Create a fetch request from the Entry object.
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // Create a sort descriptor that will sort the entries based on their mood and timestamp
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "mood", ascending: true),
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        // Create a constant that references your core data stack's mainContext.
        let fetchRequestController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: CoreDataStack.shared.mainContext,
                                                                sectionNameKeyPath: "mood",
                                                                cacheName: nil)
        
        fetchRequestController.delegate = self
        // Perform the fetch request using the fetched results controller
        try! fetchRequestController.performFetch()
        return fetchRequestController
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
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        return sectionInfo.name.capitalized
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "journalTitleCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

        let entry = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = entry.title
        cell.excerptLabel.text = entry.bodyText
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        cell.dateAndTimeLabel.text = "\(dateFormatter.string(from: entry.timestamp ?? Date() ))"
        return cell
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = fetchedResultsController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            
            context.delete(entry)
            entryController.deleteEntryFromServer(entry: entry)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving context after deleting Task: \(error)")
                context.reset()
            }
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEntryDetailSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }

            detailVC.entry = fetchedResultsController.object(at: indexPath)
        } else if segue.identifier == "CreateEntrySegue" {
            if let navC = segue.destination as? UINavigationController,
                let createEntryVC = navC.viewControllers.first as? CreateEntryViewController {
                createEntryVC.entryController = entryController
            }
        }
    }
}

// MARK: - Extension
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
