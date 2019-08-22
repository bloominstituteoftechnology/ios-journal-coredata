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
		let entry = Entry(title: title, story: story, lastUpdated: Date(), mood: mood)
		
		saveToPersistentStore()
		putInDB(entry: entry)
	}
	
	func updateEntry(entry: Entry, title: String, story: String?, mood: MoodEmoji) {
		entry.title = title
		entry.story = story
		entry.lastUpdated = Date()
		entry.mood = mood.rawValue
		
		saveToPersistentStore()
		putInDB(entry: entry)
	}
	
	func delete(entry: Entry) {
		deleteFromDB(entry: entry)
		let moc = CoreDataStack.shared.mainContext
		
		moc.delete(entry)
		saveToPersistentStore()
		
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
				
				//See if the same id exists in CoreData
				for entryRep in entryReps {
					guard let id = entryRep.id else { continue }
					let predicate  = NSPredicate(format: "id == %@", id as NSUUID)
					let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
					fetchRequest.predicate = predicate
					
					let moc = CoreDataStack.shared.mainContext
					let entry = try moc.fetch(fetchRequest).first
					
					if let entry = entry {
						entry.title = entryRep.title
						entry.story = entryRep.bodyText
						entry.mood = entryRep.mood
						entry.lastUpdated = entryRep.timestamp
					} else {
						_ = Entry(entryRepresentation: entryRep)
					}
				}
				self.saveToPersistentStore()
				completion(.success(true))
			} catch {
				completion(.failure(.notDecoding))
			}
			}.resume()
	}
	
	func putInDB(entry: Entry, completion: ((Result<Bool, NetworkError>) -> Void)? = nil) {
		let id = entry.id ?? UUID()
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
