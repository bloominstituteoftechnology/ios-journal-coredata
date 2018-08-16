//
//  JournalModel.swift
//  Journal
//
//  Created by William Bundy on 8/13/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation
import CoreData
enum EntryMood : String {
	case DeeplyUnhappy = "🙃"
	case Dissatisfied = "😕"
	case Fine = "🙂"
	case Joyful = "😋"

	static let all:[EntryMood] = [.DeeplyUnhappy, .Dissatisfied, .Fine, .Joyful]
}


extension JournalEntry: Encodable
{
	convenience init(_ title:String, _ text:String, _ mood:EntryMood = EntryMood.Fine, moc:NSManagedObjectContext = CoreDataStack.shared.mainContext)
	{
		self.init(context: moc)
		self.title = title
		self.text = text
		self.timestamp = Date()
		self.identifier = UUID().uuidString
		self.mood = mood.rawValue
	}

	convenience init(_ stub:EntryStub, moc:NSManagedObjectContext = CoreDataStack.shared.mainContext)
	{
		self.init(context: moc)
		applyStub(stub)
	}

	func applyStub(_ stub:EntryStub)
	{
		self.title = stub.title
		self.text = stub.text
		self.timestamp = stub.timestamp
		self.identifier = stub.identifier
		self.mood = stub.mood
	}

	enum CodingKeys:CodingKey
	{
		case title
		case text
		case timestamp
		case identifier
		case mood
	}

	public func encode(to encoder: Encoder) throws
	{
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(title, forKey: CodingKeys.title)
		try container.encode(text, forKey: CodingKeys.text)
		try container.encode(timestamp, forKey: CodingKeys.timestamp)
		try container.encode(getIdSafely(), forKey: CodingKeys.identifier)
		try container.encode(mood, forKey: CodingKeys.mood)
	}

	func getIdSafely() -> String
	{
		let id = self.identifier ?? UUID().uuidString
		self.identifier = id
		return id
	}

	func getStub() -> EntryStub
	{
		let stub:EntryStub = EntryStub(
			title: self.title ?? "nil",
			text: self.text ?? "nil",
			timestamp: self.timestamp ?? Date(),
			identifier: self.identifier ?? UUID().uuidString,
			mood: self.mood ?? EntryMood.Fine.rawValue)
		return stub
	}
}

struct EntryStub: Equatable, Codable
{
	var title:String
	var text:String
	var timestamp:Date
	var identifier:String
	var mood:String

	static func ==(l:EntryStub, r:JournalEntry) ->Bool
	{
		return l.identifier == r.getIdSafely()
	}
}

class CoreDataStack
{
	static let shared = CoreDataStack()
	lazy var container:NSPersistentContainer = {
		let con = NSPersistentContainer(name:"Journal")
		con.loadPersistentStores(completionHandler: {_, error in
			if let error = error {
				NSLog("Failed to load persistent store")
				fatalError()
			}
		})

		con.viewContext.automaticallyMergesChangesFromParent = true

		return con
	}()

	var mainContext:NSManagedObjectContext { return container.viewContext }

	static func save(_ moc:NSManagedObjectContext, withReset:Bool = true)
	{
		moc.perform {
			do {
				try moc.save()
			} catch {
				App.logError(EmptyHandler, "Failed to save moc: \(error)")
				if withReset {
					moc.reset()
				}
			}
		}
	}
}

typealias ErrorString = String
typealias CompletionHandler = (ErrorString?)->Void
let EmptyHandler:CompletionHandler = {_ in}
enum App
{
	static let baseURL = URL(string:"https://pushier-and-postier.firebaseio.com/")!
	static var controller = EntryController()

	static func logError(_ completion:@escaping CompletionHandler, _ error:String)
	{
		NSLog(error)
		completion(error)
	}
}

func buildRequest(_ ids:[String], _ httpMethod:String, _ data:Data?=nil) -> URLRequest
{
	var url = App.baseURL
	for id in ids {
		url.appendPathComponent(id)
	}
	url.appendPathExtension("json")
	var req = URLRequest(url: url)
	req.httpMethod = httpMethod
	req.httpBody = data
	return req
}

class EntryController
{
	static var shared = EntryController()
	lazy var fetchController:NSFetchedResultsController<JournalEntry> = {
		let moc = CoreDataStack.shared.mainContext
		var req:NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
		req.sortDescriptors = [NSSortDescriptor(key:"mood", ascending:false), NSSortDescriptor(key: "timestamp", ascending: false)]
		var fetcher = NSFetchedResultsController(
    			fetchRequest: req,
    			managedObjectContext: moc,
    			sectionNameKeyPath: "mood",
    			cacheName: nil)
		try! fetcher.performFetch()

		return fetcher
	}()

	@discardableResult
	func create(_ title:String, _ text:String, _ mood:EntryMood = .Fine, doSync:Bool = true,
				moc:NSManagedObjectContext = CoreDataStack.shared.mainContext) -> JournalEntry
	{
		var e:JournalEntry?
		moc.performAndWait {
			let entry = JournalEntry(title, text, mood, moc:moc)
			e = entry
			if doSync {
				put(entry)
			}
		}
		return e!
	}

	// this is provided so that
	func save(moc:NSManagedObjectContext = CoreDataStack.shared.mainContext, withReset:Bool = true)
	{
		putAll()
		CoreDataStack.save(moc, withReset: withReset)
	}


	func update(_ entry:JournalEntry)
	{
		put(entry)
	}


	func delete(_ entry:JournalEntry, _ completion:@escaping CompletionHandler = EmptyHandler)
	{
		let req = buildRequest([entry.getIdSafely()], "DELETE")
		URLSession.shared.dataTask(with: req) { (_, _, error) in
			if let error = error {
				App.logError(completion, "Error deleting data: \(error)")
				return
			}

			completion(nil)
		}.resume()
		let moc = CoreDataStack.shared.mainContext
		moc.delete(entry)
	}


	func put(_ entry:JournalEntry, _ completion:@escaping CompletionHandler = EmptyHandler)
	{
		let req = buildRequest([entry.getIdSafely()], "PUT", try! JSONEncoder().encode(entry))
		URLSession.shared.dataTask(with: req) { (_, _, error) in
			if let error = error {
				App.logError(completion, "Error putting data: \(error)")
				return
			}

			completion(nil)
		}.resume()
	}

	func putAll(_ completion:@escaping CompletionHandler = EmptyHandler)
	{
		var data:Data?
		do {
			var entries:[String:EntryStub] = [:]
			guard let fetched = fetchController.fetchedObjects else {App.logError(completion, "No entries to put"); return}
			for entry in fetched {
				let stub = entry.getStub()
				entries[stub.identifier] = stub
			}
			data = try JSONEncoder().encode(entries)
		} catch {
			App.logError(completion, "Error putting: failed to encode json: \(error)")
			return
		}
		let req = buildRequest([], "PUT", data)
		URLSession.shared.dataTask(with: req) { (_, _, error) in
			if let error = error {
				App.logError(completion, "Error putting data: \(error)")
				return
			}

			completion(nil)
			}.resume()
	}

	func fetchRemote(moc:NSManagedObjectContext = CoreDataStack.shared.mainContext, _ completion:@escaping CompletionHandler = EmptyHandler)
	{
		let req = buildRequest([], "GET")
		URLSession.shared.dataTask(with: req) { (data, _, error) in
			if let error = error {
				App.logError(completion, "Error fetching data: \(error)")
				return
			}

			guard let data = data else {
				App.logError(completion, "Error fetching data: no data returned")
				return
			}

			do {
				let entryStubs = try JSONDecoder().decode([String:EntryStub].self, from: data)
				for (_, stub) in entryStubs {
					try self.findAndUpdateEntryFromStub(stub, moc: moc)
				}

				CoreDataStack.save(moc)
				completion(nil)
			} catch {
				App.logError(completion, "Error fetching data: could not decode json")
			}
		}.resume()
	}

	func fetchRemoteOnBackgroundContext(_ completion: @escaping CompletionHandler = EmptyHandler)
	{
		let bg = CoreDataStack.shared.container.newBackgroundContext()
		fetchRemote(moc:bg, completion)
		// free the bg context???
	}

	func updateEntryWithStub(_ entry:JournalEntry, _ stub:EntryStub)
	{
		entry.managedObjectContext?.performAndWait {
			entry.applyStub(stub)
			self.update(entry)
		}
	}

	func findAndUpdateEntryFromStub(_ stub:EntryStub, moc:NSManagedObjectContext = CoreDataStack.shared.mainContext) throws
	{
		var caughtError:Error?
		moc.performAndWait {
			let req:NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
			req.predicate = NSPredicate(format: "identifier ==  %@", stub.identifier)
			var local:JournalEntry?
			do {
				local = try moc.fetch(req).first
			} catch {
				caughtError = error
				return
			}
			if let local = local {
				local.applyStub(stub)
			} else {
				let e = self.create(
					stub.title,
					stub.text,
					EntryMood(rawValue:stub.mood) ?? EntryMood.Fine,
					doSync: false,
					moc:moc)
				e.identifier = stub.identifier
				e.timestamp = stub.timestamp
			}
		}

		if let caughtError = caughtError {
			throw caughtError
		}
	}


}
