//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/18/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit
import CoreData

class JournalTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)
        guard let entryCell = cell as? EntryTableViewCell else { return cell }
        entryCell.entry = fetchedResultsController.object(at: indexPath)
        return entryCell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionDetail = fetchedResultsController.sections?[section] else { return nil }
        return sectionDetail.name.capitalized
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .delete:
            tableView.deleteSections([sectionIndex], with: .automatic)
        case .insert:
            tableView.insertSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let indexPath = indexPath else { return }
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
            let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJournalDetail" {
            guard let entryVC = segue.destination as? JournalDetailViewController,
                let index = tableView.indexPathForSelectedRow else { return }
            entryVC.entryController = entryController
            entryVC.entry = fetchedResultsController.object(at: index)
        }
        
        if segue.identifier == "AddJournalEntry" {
            guard let entryVC = segue.destination as? JournalDetailViewController else { return }
            entryVC.entryController = entryController
        }
    }
    
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)

        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()

}
