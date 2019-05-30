//
//  EntriesTableViewController.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        //1. create fetchrequest
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        //2. add sortDescriptors to the fetch request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        //3. access the MOC to use in the initialization of the nsfrc
        let moc = CoreDataStack.shared.mainContext
        
        //4.initialize the nsfrc so that we can return it
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        
        //5. set the nsfrc delegate to this class
        fetchedResultsController.delegate = self
        
        //6. perform, set, call, the frc
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error trying to perform frc: \(error)")
        }
        
        //7. return the frc
        return fetchedResultsController
        
    }()
    
    let ec = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
//        print("These are the entries: \(ec.entries)")
        ec.fetchEntriesFromServer { (error) in
            if let error = error {
                print("Error right here: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //frc has arrays called sections so we use that and subscript it with the section parameter in the func declaration to get the number of objects i.e. count.
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as! EntryTableViewCell

        // Configure the cell...
        //remeber to cast the cell as EntryTableViewCell, then pass an Entry to the cell's entry property in order for it to call the updateViews() method to fill in the information for the cell's labels.
        let entryToPass = fetchedResultsController.object(at: indexPath)
        cell.entry = entryToPass
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entryToDelete = fetchedResultsController.object(at: indexPath)
            ec.delete(entry: entryToDelete)
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    //MARK: - NSFRC DELEGATE METHODS
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //what do we want to do to the table view based on the change type?
        switch type {
            
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            //insert a cell when we add a model object
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            //we need both indexpaths, from indexpath to newIndexpath
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController, let index = tableView.indexPathForSelectedRow else { return }
            let entryToPass = fetchedResultsController.object(at: index)
            detailVC.entry = entryToPass
            detailVC.ec = ec
        }
        
        if segue.identifier == "AddSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            detailVC.ec = ec
        }
    }
}
