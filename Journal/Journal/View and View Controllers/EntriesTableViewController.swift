//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Andrew Liao on 8/13/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    // MARK: - NSFetchedResultsControllerDelegate methods
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
        //decides what to do when section is changed, i.e. deleted or added item will affect the sections displayed
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer:sectionIndex), with: .automatic)
        default:
            break
        }
    }


    //decides what to do when objects are changed
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            //if object is inserted then we need to tell tableView to insert a row
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            //if object is deleted then we need to tell tableView to delete old indexPath
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            //if object needs to be updated then we need to tell tableView to reload the rows
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            //if object needs to be moved then we need to tell tableView to delete old row and insert new row.
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        cell.entry = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    // Override to support deleting the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.delete(entry:fetchedResultsController.object(at: indexPath))
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EntryDetailViewController
        
        if segue.identifier == "ViewEntry"{
            guard let indexPath = tableView.indexPathForSelectedRow  else {return}
            destinationVC.entry = fetchedResultsController.object(at: indexPath)
            destinationVC.entryController = entryController
        }
        if segue.identifier == "CreateEntry"{
            destinationVC.entryController = entryController
        }
        
    }
    
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let request:NSFetchRequest<Entry> = Entry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: false),
            NSSortDescriptor(key: "timeStamp", ascending: false)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "mood", //tells NSFRC to section by mood
            cacheName: nil)
        frc.delegate = self
        try! frc.performFetch() //There should be no issues with perform fetch. If there is then something seriously bad went wrong
        return frc
    }()
    
}
