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
	convenience init(_ title:String, _ text:String, _ mood:EntryMood = EntryMood.Fine, _ moc:NSManagedObjectContext = CoreDataStack.shared.mainContext)
	{
		self.init(context: moc)
		self.title = title
		self.text = text
		self.timestamp = Date()
		self.identifier = UUID().uuidString
		self.mood = mood.rawValue
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
}

struct EntryStub: Equatable, Decodable
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

		return con
	}()

	var mainContext:NSManagedObjectContext { return container.viewContext }
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
		req.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		var fetcher = NSFetchedResultsController(
    			fetchRequest: req,
    			managedObjectContext: moc,
    			sectionNameKeyPath: "mood",
    			cacheName: nil)
		try! fetcher.performFetch()

		return fetcher
	}()

	func save(withReset:Bool = true)
	{
		let moc = CoreDataStack.shared.mainContext
		do { try moc.save() } catch {
			if withReset {
				moc.reset()
			}
			return
		}
	}

	@discardableResult
	func create(_ title:String, _ text:String, _ mood:EntryMood = .Fine, doSync:Bool = true) -> JournalEntry
	{
		let e = JournalEntry(title, text, mood)
		if doSync {
			put(e)
		}
		return e
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


	func fetchRemote(_ completion:@escaping CompletionHandler = EmptyHandler)
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
				let entries = try JSONDecoder().decode([String:EntryStub].self, from: data)
				let moc = CoreDataStack.shared.mainContext
				for (id, entry) in entries {
					let req:NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
					req.predicate = NSPredicate(format: "identifier ==  %@", id)
					let local = try moc.fetch(req).first
					if let local = local {
						local.title = entry.title
						local.text = entry.text
						local.timestamp = entry.timestamp
						local.mood = entry.mood
					} else {
						let e = self.create(entry.title, entry.text, EntryMood(rawValue:entry.mood) ?? EntryMood.Fine,
									doSync: false)
						e.identifier = id
						e.timestamp = entry.timestamp
					}
				}
				try moc.save()
				completion(nil)
			} catch {
				App.logError(completion, "Error fetching data: could not decode json")
			}
		}.resume()


	}

}
