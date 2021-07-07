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
	
	let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!

	
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
	func createEntry(with title: String, bodyText: String, mood: Mood) {
		Entry(title: title, bodyText: bodyText, mood: mood)
		saveToPersistentStore()
	}
	
	// Update
	func updateEntry(entry: Entry, with title: String, bodyText: String, mood: Mood) {
		entry.title = title
		entry.bodyText  = bodyText
		entry.mood = mood.rawValue
		saveToPersistentStore()
	}
	
	// Delete
	func deleteEntry(entry: Entry) {
		let moc = CoreDataStack.shared.mainContext
		moc.delete(entry)
		saveToPersistentStore()
	}
	
	func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
		
		let uuid = entry.identifier ?? UUID().uuidString
		let requestURL = baseURL.appendingPathComponent(uuid)
								.appendingPathExtension("json")
		var request = URLRequest(url: requestURL)
		request.httpMethod = "PUT"
		
		do {
			var representation = entry
		}
	}
	
}
