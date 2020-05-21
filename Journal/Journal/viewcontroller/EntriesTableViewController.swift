//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Vincent Hoang on 5/18/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    private let context = CoreDataStack.shared.mainContext
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: false),
                                        NSSortDescriptor(key: "name", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error performing initial fetch inside fetchedResultsController: \(error)")
        }
        
        return frc
    }()
    
    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "entryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EntryTableViewCell else {
            NSLog("Dequeued cell is not of type EntryTableViewCell")
            
            let errorCell = EntryTableViewCell()
            errorCell.entry = Entry(title: "Error", bodyText: "", timeStamp: Date(), mood: Mood.neutral)
            
            return errorCell
        }
        
        cell.entry = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return nil
        }
        
        return sectionInfo.name.capitalized
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
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
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                return
            }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .update:
            guard let indexPath = indexPath else {
                return
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {
                return
            }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else {
                return
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            break
        }
    }
}
