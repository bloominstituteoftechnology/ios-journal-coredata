//
//  EntryController.swift
//  Journal
//
//  Created by Percy Ngan on 10/14/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {


	func saveToPersistentStore() {

		do {
			try CoreDataStack.shared.mainContext.save()
		} catch {
			NSLog("Error saving context: \(error)")
		}
	}

	func loadFromPersistentStore() -> [Entry] {

		//var entries: [Entry]

		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		let moc = CoreDataStack.shared.mainContext

		do {
			let entries = try moc.fetch(fetchRequest)
			return entries
		} catch {
			NSLog("Error fetching entries: \(error)")
			return []
		}
	}

	var entries: [Entry] {
		loadFromPersistentStore()
	}

	// MARK: - CRUD Methods

	// Create
	func createEntry(title: String, timestamp: Date, identifier: String, bodyText: String, context: NSManagedObjectContext) {
		Entry(title: title, timestamp: timestamp, identifier: identifier, bodyText: bodyText, context: context)
		CoreDataStack.shared.saveToPersistentStore()
	}

	// Read

	// Update
	func updateTask(entry: Entry, title: String, timestamp: Date, bodyText: String) {
		entry.title = title
		entry.bodyText = bodyText
		entry.timestamp = timestamp
		CoreDataStack.shared.saveToPersistentStore()
	}

	// Delete
	func deleteTask(entry: Entry) {
		let mainC = CoreDataStack.shared.mainContext
		mainC.delete(entry)
		CoreDataStack.shared.saveToPersistentStore()
	}


}


