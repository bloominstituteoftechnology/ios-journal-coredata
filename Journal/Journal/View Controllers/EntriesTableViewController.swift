//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Dillon P on 10/4/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchedRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchedRequest.sortDescriptors = [
            NSSortDescriptor(key: "mood", ascending: false),
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func didRefresh(_ sender: Any) {
        entryController.fetchEntriesFromServer() { (_) in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        guard let sectionName = Mood(rawValue: sectionInfo.name) else { return nil }
        return sectionName.mood
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

        let entry = fetchedResultsController.object(at: indexPath)
        cell.entry = entry

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.deleteEntry(entry: entry)
            tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntryShowSegue" {
            if let addEntryVC = segue.destination as? EntryDetailViewController {
                addEntryVC.entryController = entryController
            }
        } else if segue.identifier == "ShowEntryDetailSegue" {
            if let entryDetailVC = segue.destination as? EntryDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                let entry = fetchedResultsController.object(at: indexPath)
                entryDetailVC.entry = entry
                entryDetailVC.entryController = entryController
                
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
                break /// break == we're aware we're not handling stuff and intentionally doing that
            }
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .update:
                guard let indexPath = indexPath else { return }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .move:
                guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
    //            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
    //            tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            case .delete:
                guard let indexPath = indexPath else { return }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            @unknown default:
                break
            }
        }
    
}
