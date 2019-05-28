//
//  EntryController.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

	var entries: [Entry] {
		return loadFromPersistentStore()
	}

	@discardableResult func create(entryWithTitle title: String, andBody bodyText: String, andMood mood: Mood) -> Entry {
		let entry = Entry(title: title, bodyText: bodyText, mood: mood)
		saveToPersistenStore()
		return entry
	}

	func update(withTitle title: String, andBody bodyText: String, andMood mood: Mood, onEntry entry: Entry) {
		entry.title = title
		entry.bodyText = bodyText
		entry.mood = mood.rawValue
		entry.timestamp = Date()
		saveToPersistenStore()
	}

	func delete(entry: Entry) {
		let moc = CoreDataStack.shared.mainContext
		moc.delete(entry)
		saveToPersistenStore()
	}

	// MARK: Persistence
	func saveToPersistenStore() {
		let moc = CoreDataStack.shared.mainContext
		do {
			try moc.save()
		} catch {
			print("error saving persistent store: \(error)")
		}
	}

	func loadFromPersistentStore() -> [Entry] {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		let moc = CoreDataStack.shared.mainContext
		do {
			return try moc.fetch(fetchRequest)
		} catch {
			print("error fetching: \(error)")
			return []
		}
	}
}
