//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()
    
    lazy var fetchedResultController: NSFetchedResultsController<Entry> = {
        
        // creating fetch request
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "mood",
                             ascending: true),
            NSSortDescriptor(key: "title",
                             ascending: true)
        ]
        // creating managed object context
        let moc = CoreDataStack.shared.mainContext
        
        // created fetched results controller
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        
        // setting fetched results controller delegate to self
        frc.delegate = self
        
        // try to perform fetch of data
        try! frc.performFetch()
        
        // return frc after fetching data
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
        return fetchedResultController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultController.sections?[section] else { return nil }
        return sectionInfo.name
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()
        }
        
        let entry = fetchedResultController.object(at: indexPath)
        cell.entry = entry

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultController.object(at: indexPath)
            entryController.delete(entry: entry)
            tableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailJournalSegue" {
            if let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entryController = self.entryController
                detailVC.entry = fetchedResultController.object(at: indexPath)
            }
        } else if segue.identifier == "AddJournalSegue" {
            if let detailVC = segue.destination as? EntryDetailViewController {
                detailVC.entryController = self.entryController
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
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath],
                                 with: .automatic)
        case.update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath],
                                 with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
            let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath],
                                 with: .automatic)
            tableView.insertRows(at: [newIndexPath],
                                 with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath],
                                 with: .automatic)
        @unknown default:
            break
        }
    }
}
