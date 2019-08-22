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

	init() {
		fetchEntriesFromServer()
	}

	let baseURL = URL(string: "https://journal-797ea.firebaseio.com/journal")!

	func createEntry(title: String, bodyText: String, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		context.performAndWait {
			let entry = Entry(title: title, bodyText: bodyText, mood: mood)
			do {
				try CoreDataStack.shared.save(context: context)
			} catch {
				NSLog("Error when saving context when creating Entry: \(error)")
			}
			put(entry: entry)
		}
	}

	func updateEntry(entry: Entry, title: String, bodyText: String, date: Date = Date(), mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		context.performAndWait {
			entry.title = title
			entry.bodyText = bodyText
			entry.timeStamp = date
			entry.mood = mood.rawValue
			put(entry: entry)
		}
		do {
			try CoreDataStack.shared.save(context: context)
		} catch {
			NSLog("Error saving context when updating Entry: \(error)")
		}
	}

	func deleteEntry(entry: Entry, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		context.performAndWait {
			deleteEntryFromServer(entry: entry)
			let moc = CoreDataStack.shared.mainContext
			moc.delete(entry)
			do {
				try CoreDataStack.shared.save(context: context)
			} catch {
				NSLog("Error saving context when deleting Entry: \(error)")
			}
		}
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
}


extension EntryController {

	func put(entry: Entry, completion: @escaping(Error?) -> Void = { _ in }) {
		guard let identifier = entry.identifier else { return }
		let requestURL = baseURL
			.appendingPathComponent(identifier)
			.appendingPathExtension("json")
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.put.rawValue

		do {
			let entryData = try JSONEncoder().encode(entry.entryRepresentation)
			request.httpBody = entryData
		} catch {
			NSLog("Error encoding entry representation: \(error)")
			completion(error)
			return
		}

		URLSession.shared.dataTask(with: request) { (_, _, error) in
			if let error = error {
				NSLog("Error PUTing entry representation to server: \(error)")
			}
			completion(nil)
		}.resume()
	}

	func deleteEntryFromServer(entry: Entry, completion: @escaping(Error?) -> Void = { _ in }) {
		guard let identifier = entry.identifier else {
			completion(nil)
			return
		}

		let requestURL = baseURL
			.appendingPathComponent(identifier)
			.appendingPathExtension("json")
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.delete.rawValue

		URLSession.shared.dataTask(with: request) { (_, _, error) in
			if let error = error {
				NSLog("Error deleting task: \(error)")
			}
			completion(nil)
		}.resume()
	}

	func update(entry: Entry, entryRepresentation: EntryRepresentation) {
		entry.title = entryRepresentation.title
		entry.bodyText = entryRepresentation.bodyText
		entry.timeStamp = entryRepresentation.timeStamp
		entry.mood = entryRepresentation.mood
		entry.identifier = entryRepresentation.identifier
	}

	func fetchingSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
		let predicate = NSPredicate(format: "identifier == %@", identifier)
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		fetchRequest.predicate = predicate

		var entry: Entry? = nil

		context.performAndWait {
			do {
				entry = try context.fetch(fetchRequest).first
			} catch {
				NSLog("Error fetching entry")
			}
		}
		return entry
	}

	func fetchEntriesFromServer(completion: @escaping(Error?) -> Void = { _ in }) {
		let requestURL = baseURL.appendingPathExtension("json")
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.get.rawValue

		URLSession.shared.dataTask(with: request) { (data, _, error) in
			if let error = error {
				NSLog("Error fetching single Entry: \(error)")
				return
			}

			guard let data = data else {
				NSLog("No data returned from data task")
				return
			}

			do {
				let entryData = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
				let entries = Array(entryData.values)
				let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
				self.updatePersistentStore(with: entries, context: backgroundContext)
			} catch {
				NSLog("Error decoding Entry Representations: \(error)")
			}
			completion(nil)
		}.resume()
	}

	func updatePersistentStore(with entryRepresentations: [EntryRepresentation], context: NSManagedObjectContext) {
		context.performAndWait {
			for entryRepresention in entryRepresentations {
				guard let identifier = entryRepresention.identifier else { return }
				let entry = self.fetchingSingleEntryFromPersistentStore(identifier: identifier, context: context)

				if let entry = entry {
					if entryRepresention != entry {
						self.update(entry: entry, entryRepresentation: entryRepresention)
					}
				} else {
					Entry(entryRepresentation: entryRepresention, context: context)
				}
			}
		}

		do {
			try CoreDataStack.shared.save(context: context)
		} catch {
			NSLog("Error saving context when updating Persistent Store: \(error)")
			context.reset()
		}
	}
}

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}
