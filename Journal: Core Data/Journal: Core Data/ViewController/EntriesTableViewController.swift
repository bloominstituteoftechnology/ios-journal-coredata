//
//  EntriesTableViewController.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true),
            NSSortDescriptor(key: "title", ascending: true)
        ]
        let mainContext = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: mainContext,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { fatalError("Can't find entry cell.")}
        cell.entry = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let entry = fetchedResultsController.object(at: indexPath)
        CoreDataStack.shared.mainContext.delete(entry)
        do {
            try CoreDataStack.shared.mainContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Failed to delete task: \(error)")
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEntry" {
            // the user tapped on a task cell
            let entryDetailViewController = segue.destination as! EntryDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                entryDetailViewController.entry = fetchedResultsController.object(at: indexPath)
            }
        }
    }
    

    // MARK: - NSFetchResultsControllerDelgate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let indexPath = newIndexPath else { return }
            tableView.insertRows(at: [indexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // didChange sectionInfo ... atSectionIndex .
    // didChange anObject ... at indexPath .
}
