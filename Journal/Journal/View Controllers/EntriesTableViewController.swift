//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var tableView: UITableView!
    
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let timeStampDiscriptor                 = NSSortDescriptor(key: "timeStamp", ascending: false)
        let moodDescriptor                      = NSSortDescriptor(key: "mood", ascending: true)
        fetchRequest.sortDescriptors            = [moodDescriptor, timeStampDiscriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error fetching from FRC:\(error)")
        }
        return frc
    }()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        entryController.fetchEntriesFromServer {
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntrySegue" {
            guard let addEntryVC       = segue.destination as? EntryDetailViewController else { return }
            addEntryVC.entryController = entryController
            addEntryVC.title           = "Add Entry"
        }
        
        if segue.identifier == "EntryDetailSegue" {
            guard let entryDetailVC = segue.destination as? EntryDetailViewController,
                  let indexPath     = tableView.indexPathForSelectedRow else { return }
            entryDetailVC.entryController = entryController
            entryDetailVC.entry           = fetchedResultsController.object(at: indexPath)
        }
    }
}

// MARK: - Extensions

extension EntriesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        let entry      = fetchedResultsController.object(at: indexPath)
        cell.entry     = entry
         return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryToDelete = fetchedResultsController.object(at: indexPath)
            entryController.deleteEntry(entry: entryToDelete)
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let sectionIndexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(sectionIndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionIndexSet, with: .automatic)
        default:
            break
        }
    }
}
