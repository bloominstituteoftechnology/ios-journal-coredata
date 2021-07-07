//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Propeties
    
    let entryController = EntryController()
    
    lazy var fetchedResultController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood",
                                                         ascending: true),
                                        NSSortDescriptor(key: "timestamp",
                                                         ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
        return fetchResultsController
    }()

    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.90)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Keys.entryCellName, for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        cell.entry = fetchedResultController.object(at: indexPath)
        cell.layer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
        cell.layer.cornerRadius = 10
            return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultController.sections?[section] else {
            return nil
        }
        
        return sectionInfo.name
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView  else { return }
        header.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        if let textLabel = header.textLabel {
            textLabel.font = textLabel.font.withSize(30)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultController.object(at: indexPath)
            CoreDataStack.shared.mainContext.delete(entry)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                CoreDataStack.shared.mainContext.reset()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.addEntrySegue {
            if let addEntryVC = segue.destination as? EntryDetailViewController {
                addEntryVC.entryController = entryController
            }
        }
        if segue.identifier == Keys.viewEditEntrySegue {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let editEntryVC = segue.destination as? EntryDetailViewController else { return }
            editEntryVC.entryController = entryController
            editEntryVC.entry = fetchedResultController.object(at: indexPath)
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
            tableView.insertSections(IndexSet(integer: sectionIndex),
                                     with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex),
                                     with: .automatic)
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
            tableView.insertRows(at: [newIndexPath],
                                 with: .automatic)
        case .update:
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
            guard let oldIndexPath = indexPath else { return }
            tableView.deleteRows(at: [oldIndexPath],
                                 with: .automatic)
        @unknown default:
            break
        }
    }
}
