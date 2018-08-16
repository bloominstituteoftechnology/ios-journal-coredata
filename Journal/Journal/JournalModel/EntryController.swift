
import Foundation
import UIKit
import CoreData

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
