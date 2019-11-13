//
//  CoreDataStack.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import CoreData

// MARK: - CoreDataStack Delegate

protocol CoreDataStackDelegate {
    func entriesWillChange()
    func entriesDidChange()
    func sectionChanged(atIndex sectionIndex: Int, with type: EntryController.ChangeType)
    func entryChanged(from indexPath: IndexPath?, to newIndexPath: IndexPath?, with type: EntryController.ChangeType)
}

class CoreDataStack: NSObject {
    // MARK: - Properties
    
    lazy var container: NSPersistentContainer = {
        // `NAME` MUST MATCH XCDATAMODELD FILENAME
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    var delegate: CoreDataStackDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "mood", ascending: true),
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "mood",
            cacheName: nil
        )
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching results from data: \(error)")
        }
        return frc
    }()
}

// MARK: - FRC Delegate

extension CoreDataStack: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.entriesWillChange()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.entriesDidChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        delegate?.sectionChanged(atIndex: sectionIndex, with: type)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.entryChanged(from: indexPath, to: newIndexPath, with: type)
    }
}
