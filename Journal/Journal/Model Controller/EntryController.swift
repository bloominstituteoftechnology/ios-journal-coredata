//
//  EntryController.swift
//  Journal
//
//  Created by Bree Jeune on 4/24/20.
//  Copyright © 2020 Young. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func create(title: String, bodyText: String) {
        let _ = Entry(title: title, bodyText: bodyText)
        saveToPersistenceStore()
    }

    func update(entry: Entry, title: String, bodyText: String) {
        entry.title = title
            entry.bodyText = bodyText
            entry.timestamp = Date()
            saveToPersistenceStore()
    }

    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
                moc.delete(entry)

                do {
                    try moc.save()
                } catch {
                    NSLog("Error deleting data from persistence store: \(error)")
                }
                
            }
            
            func saveToPersistenceStore() {
                let moc = CoreDataStack.shared.mainContext
                
                do {
                    try moc.save()
                } catch {
                    NSLog("Error saving data from persistence store: \(error)")
                }
            }
            
            func loadFromPersistenceStore() -> [Entry] {
                let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
                let moc = CoreDataStack.shared.mainContext
                
                do {
                    return try moc.fetch(fetchRequest)
                } catch {
                    NSLog("Error fetching data from persistence store: \(error)")
                    return []
                }
            }
            
            var entries: [Entry] {
                return loadFromPersistenceStore()
            }
            
        }
