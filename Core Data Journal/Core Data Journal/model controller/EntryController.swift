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

	init() {
		remoteGetEntriesFromServer { (result: Result<[EntryRepresentation], NetworkError>) in
			do {
				_ = try result.get()
				print("success getting")
			} catch {
				print("error getting: \(error)")
			}
		}
	}

	@discardableResult func create(entryWithTitle title: String, andBody bodyText: String, andMood mood: Mood) -> Entry {
		let entry = Entry(title: title, bodyText: bodyText, mood: mood)
		saveToPersistenStore()
		remotePut(entry: entry) { (result: Result<EntryRepresentation, NetworkError>) in
			do {
				_ = try result.get()
			} catch {
				NSLog("\(error)")
			}
		}
		return entry
	}

	func update(withTitle title: String, andBody bodyText: String, andMood mood: Mood, onEntry entry: Entry) {
		entry.title = title
		entry.bodyText = bodyText
		entry.mood = mood.rawValue
		entry.timestamp = Date()
		saveToPersistenStore()
		remotePut(entry: entry) { (result: Result<EntryRepresentation, NetworkError>) in
			do {
				_ = try result.get()
			} catch {
				NSLog("\(error)")
			}
		}
	}

	func delete(entry: Entry) {
		let moc = CoreDataStack.shared.mainContext
		remoteDelete(entry: entry) { (result: Result<Data?, NetworkError>) in
			do {
				_ = try result.get()
				print("success")
			} catch {
				NSLog("error deleting from firebase: \(error)")
			}
		}
		moc.delete(entry)
		saveToPersistenStore()
	}

	// MARK: - Local Persistence
	func saveToPersistenStore() {
		let moc = CoreDataStack.shared.mainContext
		do {
			try moc.save()
		} catch {
			print("error saving persistent store: \(error)")
		}
	}

	func fetchFromPersistentStore(entryID: String) -> Entry? {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "identifier == %@", entryID)
		let moc = CoreDataStack.shared.mainContext
		do {
			return try moc.fetch(fetchRequest).first
		} catch {
			NSLog("error fetching single entry: \(error)")
			return nil
		}
	}

	// MARK: - Remote Persistence
	let networkHandler = NetworkHandler()

	let baseURL = URL(string: "https://lambda-school-mredig.firebaseio.com/coreDataJournal")!

	func remotePut(entry: Entry, completion: @escaping (Result<EntryRepresentation, NetworkError>) -> Void = { _ in }) {
		let identifier = entry.identifier ?? UUID().uuidString
		let putURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
		entry.identifier = identifier

		var request = URLRequest(url: putURL)
		request.httpMethod = HTTPMethods.put.rawValue

		guard let entryRep = entry.entryRepresentation else {
			completion(.failure(.otherError(error: NSError())))
			return
		}
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .secondsSince1970
		do {
			request.httpBody = try encoder.encode(entryRep)
		} catch {
			completion(.failure(.dataCodingError(specifically: error)))
			return
		}

		networkHandler.transferMahCodableDatas(with: request, completion: completion)
	}

	func remoteDelete(entry: Entry, completion: @escaping (Result<Data?, NetworkError>) -> Void = { _ in }) {
		let identifier = entry.identifier ?? UUID().uuidString
		let deleteURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
		entry.identifier = identifier

		var request = URLRequest(url: deleteURL)
		request.httpMethod = HTTPMethods.delete.rawValue

		networkHandler.transferMahOptionalDatas(with: request, completion: completion)
	}

	func remoteGetEntriesFromServer(completion: @escaping (Result<[EntryRepresentation], NetworkError>) -> Void = { _ in }) {
		let getURL = baseURL.appendingPathExtension("json")

		let request = getURL.request

		networkHandler.netDecoder.dateDecodingStrategy = .secondsSince1970
		networkHandler.transferMahCodableDatas(with: request) { [weak self] (result: Result<[String: EntryRepresentation], NetworkError>) in
			do {
				let entryDict = try result.get()
				let entryRepsArray = Array(entryDict.values)
				for entryRep in entryRepsArray {
					if let entry = self?.fetchFromPersistentStore(entryID: entryRep.identifier) {
						if entry != entryRep {
							self?.update(entry: entry, fromRep: entryRep)
						}
					} else {
						_ = Entry(representation: entryRep)
					}
				}
				self?.saveToPersistenStore()
				completion(.success(entryRepsArray))
			} catch {
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	private func update(entry: Entry, fromRep representation: EntryRepresentation) {
		entry.title = representation.title
		entry.bodyText = representation.bodyText
		entry.mood = representation.mood
		entry.timestamp = representation.timestamp
	}
}
