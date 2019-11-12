//
//  EntryController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import CoreData

protocol EntryControllerDelegate: NSFetchedResultsControllerDelegate {}

class EntryController {
    
    // MARK: - Properties
    
    private var coreDataStack = CoreDataStack()
    var delegate: EntryControllerDelegate?
    
    // MARK: - Entry Fetching
    
    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func sectionTitle(for section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section]
            else { return nil }
        return sectionInfo.name.capitalized
    }
    
    func fetch(entryAt indexPath: IndexPath) -> Entry {
        return fetchedResultsController.object(at: indexPath)
    }
    
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
        frc.delegate = delegate
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching results from data: \(error)")
        }
        return frc
    }()
    
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
    
    // MARK: - Save/Load
    
    func saveToPersistentStore() {
        let moc = coreDataStack.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving journal entries: \(error)")
        }
    }
}
