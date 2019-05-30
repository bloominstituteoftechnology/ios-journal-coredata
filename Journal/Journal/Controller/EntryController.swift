//
//  EntryController.swift
//  Journal
//
//  Created by Hector Steven on 5/29/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation
import CoreData


class EntryController {
	
	func put(entry: Entry, completion: @escaping (Error?) -> ()) {
		let identifier = entry.identifier ?? UUID().uuidString
		let url = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
		
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		
		do {
			guard let entryRep = entry.entryRepresentation else {
				completion(NSError())
				return
			}
			
			request.httpBody = try JSONEncoder().encode(entryRep)
			
		} catch {
			NSLog("Error encoding TaskRepresentation")
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_ , response, error) in
			if let response = response as? HTTPURLResponse{
				print("Respnse Code: \(response.statusCode)")
			}
			
			if let error = error {
				NSLog("Error puting entryRep to firebase: \(error)")
				completion(nil)
			}
			entry.identifier = identifier
		
//			try? self.save
			print(request)
			completion(nil)
		}.resume()
		
	}
	
	func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> ()) {
		let identifier = entry.identifier ?? UUID().uuidString
		let url = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
		
		var request = URLRequest(url: url)
		request.httpMethod = "DELETE"
		
		do {
			guard let entryRep = entry.entryRepresentation else {
				completion(NSError())
				return
			}
			
			request.httpBody = try JSONEncoder().encode(entryRep)
			
		} catch {
			NSLog("Error encoding TaskRepresentation")
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_ , response, error) in
			if let response = response as? HTTPURLResponse{
				print("Respnse Code: \(response.statusCode)")
			}
			
			if let error = error {
				NSLog("Error puting entryRep to firebase: \(error)")
				completion(nil)
			}
			
			entry.identifier = identifier
			
			//try? self.save
			
			completion(nil)
			}.resume()
	}
	
	func fetchEntriesFromServer(completion: @escaping (Error?) -> ()) {
		let url = baseUrl.appendingPathExtension("json")
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let response = response as? HTTPURLResponse {
				print("FetchEntries ResponseCode: \(response.statusCode)")
			}
			
			if let error = error {
				print("Error FetchingEntries: \(error)")
				completion(error)
				return
			}
			
			guard let data = data else {
				print("Error FetchingEntries: geting data")
				completion(NSError())
				return
			}
			
			print(data)
			
			
			do {
				let entryRep = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
				let entryRepArr = Array(entryRep.values)
				
				try self.updateEntry(with: entryRepArr)
			} catch {
				print("Error decoding json from firebase")
			}
			
			completion(nil)
		}.resume()
	}
	
	private let baseUrl: URL = URL(string: "https://journal-hectorsvill.firebaseio.com/")!
}

extension EntryController {
	
	func updateEntry(with entryReps: [EntryRepresentation]) throws {
		for rep in entryReps {
			let identifier = UUID(uuidString: rep.identifier)!
			if let entry = getEntryFromCoreData(forUUID: identifier) {
				entry.identifier = rep.identifier
				entry.title = rep.title
				entry.bodyText = rep.bodyText
				entry.mood = rep.mood
				entry.timeStamp = rep.timeStamp
			} else {
				let _ = Entry(entryRepresentation: rep)
			}
		}
		try saveToPresistenStore()
	}
	
	func getEntryFromCoreData(forUUID uuid: UUID) -> Entry? {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
		
		do {
			let moc = CoreDataStack.shared.mainContext
			return try moc.fetch(fetchRequest).first
		} catch {
			NSLog("Error fetching entry with uuid: \(error)")
			return nil
		}
	}
	
	func saveToPresistenStore() throws {
		let moc = CoreDataStack.shared.mainContext
		try moc.save()
	}
}
