//  Copyright © 2019 Frulwinn. All rights reserved.

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    //MARK: - Properties
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "timestamp", cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as? TableViewCell else {fatalError("unable to dequeue tableview cell") }
        
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    //tell the table view that we're going to update it
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    //tell the table view that we're done updating it
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    //how do we want to update the tableview in response to a change on a task
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
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        }
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableCellSegue" {
            
            if let destinationVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                let entry = entryController.entries[indexPath.row]
                
                destinationVC.entry = entry
                destinationVC.entryController = entryController
            }
        } else if segue.identifier == "addSegue" {
            let destinationVC = segue.destination as? DetailViewController
            destinationVC?.entryController = entryController
        }
    }
}
