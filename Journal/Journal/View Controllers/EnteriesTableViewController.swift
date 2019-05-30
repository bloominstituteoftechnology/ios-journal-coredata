//
//  EnteriesTableViewController.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import CoreData

class EnteriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchedResult: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchedResult.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true), NSSortDescriptor(key: "mood", ascending: false)]

        let fetchedRequestController = NSFetchedResultsController(fetchRequest: fetchedResult, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "mood", cacheName: nil)

        fetchedRequestController.delegate = self

        do {
            try fetchedRequestController.performFetch()
        } catch {
            NSLog("Could not fetch data: \(error)")
        }

        return fetchedRequestController
    }()

    var entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EnteryCell", for: indexPath) as? EnteryTableViewCell else { return UITableViewCell() }

        cell.entry = fetchedResultsController.object(at: indexPath)

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.delete(entry: fetchedResultsController.object(at: indexPath))

            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateEntery" {
            let destination = segue.destination as! EnteryDetailViewController

            destination.entryController = entryController
        } else if segue.identifier == "ShowEnteryDetail" {
            let destination = segue.destination as! EnteryDetailViewController

            destination.entryController = entryController

            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.entry = fetchedResultsController.object(at: indexPath)
            }
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
        case .insert:
            let sectionIndex = IndexSet(integer: sectionIndex)
            self.tableView.insertSections(sectionIndex, with: .automatic)
        case .delete:
            let sectionIndex = IndexSet(integer: sectionIndex)
            self.tableView.deleteSections(sectionIndex, with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }

            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }

}
