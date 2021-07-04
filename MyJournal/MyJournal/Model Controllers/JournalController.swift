//
//  JournalController.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

class JournalController {
	
	let baseURL = URL(string: "https://myjournal-santana.firebaseio.com/")!
	
	func createEntry(title: String, story: String?, mood: MoodEmoji) {
		CoreDataStack.shared.mainContext.performAndWait {
			let entry = Entry(title: title, story: story, lastUpdated: Date(), mood: mood)
			
			do {
				try CoreDataStack.shared.save()
			} catch {
				NSLog("Error saving context when creating a new task")
			}
			putInDB(entry: entry)
		}
	}
	
	func updateEntry(entry: Entry, title: String, story: String?, mood: MoodEmoji) {
		entry.title = title
		entry.story = story
		entry.lastUpdated = Date()
		entry.mood = mood.rawValue
		
		CoreDataStack.shared.mainContext.performAndWait {
			do {
				try CoreDataStack.shared.save()
			} catch {
				NSLog("Error saving context when updating a new task")
			}
		}
		putInDB(entry: entry)
	}
	
	func delete(entry: Entry) {
		deleteFromDB(entry: entry)
		let moc = CoreDataStack.shared.mainContext
		
		moc.performAndWait {
			moc.delete(entry)
			do {
				try CoreDataStack.shared.save()
			} catch {
				NSLog("Error saving context when deleting a new task")
			}
		}
		
	}
}

extension JournalController {
	
	func fetchEntriesFromServer(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
		let requestURL = baseURL.appendingPathExtension("json")
		
		URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
			if let error = error {
				if let response = response as? HTTPURLResponse, response.statusCode != 200 {
					NSLog("Error: status code is \(response.statusCode) instead of 200.")
				}
				NSLog("Error creating user: \(error)")
				completion(.failure(.other(error)))
				return
			}
			
			guard let data = data else {
				NSLog("No data was returned")
				completion(.failure(.noData))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				
				let EntryRepDictionary = try decoder.decode([String:EntryRepresentation].self, from: data)
				let entryReps = EntryRepDictionary.map{$0.value}
				let context = CoreDataStack.shared.container.newBackgroundContext()
				
				self.updatePersistentStore(with: entryReps, context: context)
				completion(.success(true))
			} catch {
				completion(.failure(.notDecoding))
			}
		}.resume()
	}
	
	private func updatePersistentStore(with entryRepresentations: [EntryRepresentation], context: NSManagedObjectContext) {
		
		context.performAndWait {
			//See if the same id exists in CoreData
			for entryRep in entryRepresentations {
				guard let id = entryRep.id else { continue }
				let entry = self.entry(for: id, in: context)
				
				if let entry = entry {
					entry.title = entryRep.title
					entry.story = entryRep.bodyText
					entry.mood = entryRep.mood
					entry.lastUpdated = entryRep.timestamp
				} else {
					_ = Entry(entryRepresentation: entryRep, context: context)
				}
			}
			
			do {
				try CoreDataStack.shared.save(context: context)
			} catch {
				NSLog("Error saving to core data")
				context.reset()
			}
		}
	}
	
	private func entry(for id: UUID, in context: NSManagedObjectContext) -> Entry? {
		let predicate  = NSPredicate(format: "id == %@", id as NSUUID)
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		fetchRequest.predicate = predicate
		
		var entry: Entry?
		do {
			entry = try context.fetch(fetchRequest).first
		} catch {
			NSLog("Error fetching specific id")
		}
		return entry
	}
	
	func putInDB(entry: Entry, completion: ((Result<Bool, NetworkError>) -> Void)? = nil) {
		var id = UUID()
		if let tempId = entry.id {
			id = tempId
		} else {
			#warning("update coredata entry without an id")
		}
		
		let requestURL = baseURL.appendingPathComponent(id.uuidString)
			.appendingPathExtension("json")
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.put.rawValue
		
		do {
			let entryData = try JSONEncoder().encode(entry.entryRepresentation)
			request.httpBody = entryData
		} catch {
			completion?(.failure(.notEncoding))
		}
		
		URLSession.shared.dataTask(with: request) { (_, _, error) in
			if let error = error {
				completion?(.failure(.other(error)))
			}
			completion?(.success(true))
			}.resume()
	}
	
	func deleteFromDB(entry: Entry, completion: ((Result<Bool, NetworkError>) -> Void)? = nil) {
		guard let id = entry.id else {
			completion?(.failure(.noToken))
			return
		}
		
		let requestURL = baseURL.appendingPathComponent(id.uuidString)
			.appendingPathExtension("json")
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.delete.rawValue
		
		URLSession.shared.dataTask(with: request) { (_, _, error) in
			if let error = error {
				completion?(.failure(.other(error)))
			}
			completion?(.success(true))
			}.resume()
	}
}
