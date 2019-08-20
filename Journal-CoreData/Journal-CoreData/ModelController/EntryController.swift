//
//  EntryController.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

	func createEntry(title: String, bodyText: String, identifier: String, mood: Mood) {
		Entry(title: title, identifier: identifier, bodyText: bodyText, mood: mood)
		saveToPersistentStore()
	}

	func updateEntry(entry: Entry, title: String, bodyText: String, date: Date = Date(), mood: Mood) {
		entry.title = title
		entry.bodyText = bodyText
		entry.timeStamp = date
		entry.mood = mood.rawValue
		saveToPersistentStore()
	}

	func deleteEntry(entry: Entry) {
		let moc = CoreDataStack.shared.mainContext
		moc.delete(entry)
		saveToPersistentStore()
	}

	func loadFromPersistentStore() -> [Entry] {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		let moc = CoreDataStack.shared.mainContext

		do {
			let entries = try moc.fetch(fetchRequest)
			return entries
		} catch {
			NSLog("Error fetching Entries: \(error)")
			return []
		}
	}

	func saveToPersistentStore() {
		let moc = CoreDataStack.shared.mainContext

		do {
			try moc.save()
		} catch {
			NSLog("Error saving moc: \(error)")
			moc.reset()
		}
	}
}
