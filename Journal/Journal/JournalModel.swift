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


extension JournalEntry
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
	func create(_ title:String, _ text:String, _ mood:EntryMood = .Fine) -> JournalEntry
	{
		let e = JournalEntry(title, text, mood)
		return e
	}

	func delete(_ entry:JournalEntry)
	{
		let moc = CoreDataStack.shared.mainContext
		moc.delete(entry)
	}

}
