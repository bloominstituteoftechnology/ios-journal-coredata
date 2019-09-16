//
//  EntryController.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

class EntryController: CoreDataStack {

	// MARK: - Properties

	var entry: [Entry] {
		return loadFromPersistentStore()
	}

	// MARK: - Questions: Why does compiler want the return?


	override func saveToPersistentStore() {
		do {
			try mainContext.save()
		} catch {
			NSLog("Error saving context: \(error)")
			mainContext.reset()
		}
	}

	func loadFromPersistentStore() -> [Entry] {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		do {
			let entry = try
				CoreDataStack.shared.mainContext.fetch(fetchRequest)
			return entry
		} catch {
			NSLog("Error fetching entry: \(error)")
			return[]
		}
	}

	func createEntry(with title: String, timestamp: Date, bodyText: String, identifier: String) {
		let _ = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier)
		saveToPersistentStore()
	}

	func updateEntry(entry: Entry, title: String, bodyText: String ) {
		entry.title = title
		entry.bodyText = bodyText
		saveToPersistentStore()
	}

	func deleteEntry(entry: Entry) {
		let mainC = CoreDataStack.shared.mainContext
		mainC.delete(entry)
		saveToPersistentStore()
	}



}
