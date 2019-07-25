//
//  EntriesTableViewController.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit
import  CoreData

class EntriesTableViewController: UITableViewController { 
    //Properties
    var entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            
            // FRCs NEED at least one sort descriptor. If you are giving a "sectionNameKeyPath", the first sort descriptor must be the same attribute.
        let moodDescriptor = NSSortDescriptor(key: EntryProperties.mood.rawValue, ascending: true)
            let titleDescriptor = NSSortDescriptor(key: EntryProperties.title.rawValue, ascending: true)
            
            fetchRequest.sortDescriptors = [moodDescriptor, titleDescriptor]
            
            let moc = CoreDataStack.shared.mainContext
            
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: EntryProperties.mood.rawValue, cacheName: nil)
            
            frc.delegate = self
            
            do {
                try frc.performFetch()
            } catch {
                fatalError("Error performing fetch for frc: \(error)")
            }
            
            return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        let entry = fetchedResultsController.object(at: indexPath)
        
        cell.entry = entry
        
        cell.updateViews()
        
        return cell
    }


  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

           let entry = fetchedResultsController.object(at: indexPath)

            entryController.deleteEntry(entry: entry)
            
            entryController.deleteEntryFromServer(entry: entry)

            //tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        
        return sectionInfo.name.capitalized
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "AddNewEntrySegue" {
            
            guard let newEntryVC = segue.destination as? EntryDetailViewController else {return}
            
            newEntryVC.entryController = entryController
            
        } else if segue.identifier == "EntryCellDetailSegue"{
            
            guard let selectedEntryVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let entry = fetchedResultsController.object(at: indexPath)
            selectedEntryVC.entryController = entryController
            selectedEntryVC.entry = entry
        }
        
    }
 

}

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
    // Conforming EntriesTVC as a FRCdelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        case .move:
            guard let newIndexPath = newIndexPath else { return }
            guard let indexPath = indexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
            
        @unknown default:
            break
        }
    }
    
    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let sections = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sections, with: .fade)
            
        case .delete:
            tableView.deleteSections(sections, with: .fade)
        default:
            break
        }
    }
}
