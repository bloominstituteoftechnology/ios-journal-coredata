//
//  EntriesTableViewController.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
import CoreData
class EntriesTableViewController: UITableViewController {

    var entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

 lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: true),
        NSSortDescriptor(key: "timeStamp", ascending: true)]
        let context = CoreDataStack.shared.mainContext
    let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "mood", cacheName: nil)  // we are gathering everything in this  featchrequest, manageobjejcrt contextr and everything from what we created in the constants.
        frc.delegate = self
        try! frc.performFetch()
         return frc
          
    }()
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntriesCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        let entry = fetchedResultsController.object(at: indexPath)
        cell.entry = entry
        return cell
    }
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil}
               
        return sectionInfo.name.capitalized
              
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryIndex = fetchedResultsController.object(at: indexPath)
            entryController.deleteEntry(entry: entryIndex)
        }
    }
    


    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntryModalSegue" {
            if let createEntryVC = segue.destination as? EntryDetailViewController {
                createEntryVC.entryController = entryController
            }
            
        } else if segue.identifier == "SavedEntryModalSegue" {
            if let savedEntryVC = segue.destination as? EntryDetailViewController {
                savedEntryVC.entryController = entryController
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    savedEntryVC.entry = fetchedResultsController.object(at: selectedIndex)
                }
                
            }
        }
    }
    

}

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
    //     this is the warning the tableview that the fetch controller is goijng to makechanges in the tableview.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        //        this is the beggnining of the fetchhing
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        //         the endo of the fetchhing.
    }
    //    deletes the entire section or insert entire section
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

