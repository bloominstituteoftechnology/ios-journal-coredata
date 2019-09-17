//
//  EntryController.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

	// MARK: - Properties

	var entry: [Entry] {
		return loadFromPersistentStore()
	}

	// MARK: - Questions: Why does compiler want the return?


	func saveToPersistentStore() {
		do {
			try CoreDataStack.shared.mainContext.save()
		} catch {
			NSLog("Error saving context: \(error)")
			
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

	@discardableResult func createEntry(with title: String, bodyText: String) -> Entry {
		let entry = Entry(title: title, bodyText: bodyText, context: CoreDataStack.shared.mainContext)
		saveToPersistentStore()

		return entry
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
