//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/10/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    private var entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchrequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchrequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: true),
        NSSortDescriptor(key: "title", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.backgroundColor = ColorHelper.backgroundColorNew
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return entryController.entries.count
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JornalCell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()
            
        }

//        let entry = entryController.entries[indexPath.row]
        let entry = self.fetchedResultsController.object(at: indexPath)
        
        cell.entry = entry
        
        cell.backgroundColor = ColorHelper.cellBackgroundColorNew // color

        return cell
    }
    
    
 



    // delete
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let entry = entryController.entries[indexPath.row]
            let entry = self.fetchedResultsController.object(at: indexPath)
            entryController.deleteEntryFromServer(entry) { (error) in
                if let error = error {
                    NSLog("Error deleting entry from server: \(error)")
                    return
                }
                let moc = CoreDataStack.shared.mainContext
                moc.performAndWait {
                    moc.delete(entry)
                    do {
                        try moc.save()
                        self.tableView.reloadData()
                        
                    } catch {
                        moc.reset()
                        NSLog("Error saving managed object context: \(error)")
                    }
                }
                
//            entryController.delete(entry: entry)
        }//       tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    // MARK:- NSFetchedresultcontroller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = self.fetchedResultsController.sections?[section] else {return nil}
        return sectionInfo.name.capitalized
    }
    
    //sections
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
    
    //rows
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddDetail" {
            guard let detailVC = segue.destination as? EntryDetailViewController else {return}
            detailVC.entryController = self.entryController
        }
        
        if segue.identifier == "JournalCellDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//            let entry = entryController.entries[indexPath.row]
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
//            detailVC.entryController = entryController
//            detailVC.entries = entry
            detailVC.entries = self.fetchedResultsController.object(at: indexPath)
            detailVC.entryController = self.entryController
    }
    }
    


}
