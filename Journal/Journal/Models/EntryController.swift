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

	// MARK: - Properties
	// all computed properties have to return something!
	var entries: [Entry] {
		return loadFromPersistentStore()
	}

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

	// MARK: - CRUD Methods

	// Create
	func createEntry(title: String, bodyText: String) {
		_ = Entry(title: title, bodyText: bodyText)
		//Entry(title: title, timestamp: timestamp!, identifier: identifier!, bodyText: bodyText, context: context)
		saveToPersistentStore()
	}

	// Read

	// Update
	func updateEntry(entry: Entry, title: String, bodyText: String) {
		entry.title = title
		entry.bodyText = bodyText
		saveToPersistentStore()
	}

	// Delete
	func deleteEntry(entry: Entry) {
		let mainC = CoreDataStack.shared.mainContext
		mainC.delete(entry)
		saveToPersistentStore()	}


}


