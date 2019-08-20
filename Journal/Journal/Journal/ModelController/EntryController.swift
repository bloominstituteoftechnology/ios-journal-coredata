//
//  EntryController.swift
//  Journal
//
//  Created by Taylor Lyles on 8/19/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
	
	var entries: [Entry] {
		return loadFromPersistentStore()
	}
	
	func saveToPersistentStore() {
		let moc = CoreDataStack.shared.mainContext
		
		do {
			try moc.save()
		} catch {
			NSLog("Error stating moc: /(error)")
			moc.reset()
		}
	}
	
	func loadFromPersistentStore() -> [Entry] {
		let fetchRequest: NSFetchRequest = Entry.fetchRequest()
		let moc = CoreDataStack.shared.mainContext

		do {
			let entry = try moc.fetch(fetchRequest)
			return entry
		} catch {
			NSLog("Error fetching Entry: \(error)")
			return[]
		}
	}
	
	// Create
	func createEntry(with title: String, bodyText: String) {
		Entry(title: title, bodyText: bodyText)
		saveToPersistentStore()
	}
	
	// Update
	func updateEntry(entry: Entry, with title: String, bodyText: String) {
		entry.title = title
		entry.bodyText  = bodyText
		saveToPersistentStore()
	}
	
	// Delete
	func deleteEntry(entry: Entry) {
		let moc = CoreDataStack.shared.mainContext
		moc.delete(entry)
		saveToPersistentStore()
	}
}
