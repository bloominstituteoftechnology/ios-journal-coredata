//
//  EntryController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Entry Controller Delegate

protocol EntryControllerDelegate {
    func entriesWillChange()
    func entriesDidChange()
    func sectionChanged(atIndex sectionIndex: Int, with type: EntryController.ChangeType)
    func entryChanged(from indexPath: IndexPath?, to newIndexPath: IndexPath?, with type: EntryController.ChangeType)
}

class EntryController: NSObject {
    // MARK: - Properties
    
    private var coreDataStack = CoreDataStack()
    var delegate: EntryControllerDelegate?
    
    // MARK: - Entry Fetching
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "mood", ascending: true),
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.mainContext,
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
    
    private var fetchedResultsAreEmpty: Bool {
        guard let array = fetchedResultsController.fetchedObjects
            else { return true }
        return array.isEmpty
    }
    
    func fetch(entryAt indexPath: IndexPath) -> Entry? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func mood(forIndex index: Int) -> String? {
        if fetchedResultsAreEmpty { return nil }
        let sectionInfo = fetchedResultsController.sections?[index]
        return sectionInfo?.name.capitalized
    }
    
    func numberOfMoods() -> Int {
        if fetchedResultsAreEmpty { return 0 }
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func numberOfEntries(forIndex index: Int) -> Int {
        if fetchedResultsAreEmpty { return 0 }
        return fetchedResultsController.sections?[index].numberOfObjects ?? 0
    }
    
    // MARK: - CRUD
    
    func create(entryWithTitle title: String, body: String, mood: Entry.Mood) {
        let _ = Entry(
            title: title,
            bodyText: body,
            mood: mood,
            context: coreDataStack.mainContext
        )
        saveToPersistentStore()
    }
    
    func update(entry: Entry, withNewTitle title: String, body: String, mood: Entry.Mood) {
        entry.title = title
        entry.bodyText = body
        entry.mood = mood.rawValue
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        coreDataStack.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = coreDataStack.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving journal entries: \(error)")
        }
    }
}

// MARK: - Fetched Results Controller Delegate

extension EntryController: NSFetchedResultsControllerDelegate {
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

// MARK: - Change Type

extension EntryController {
    typealias ChangeType = NSFetchedResultsChangeType
}

