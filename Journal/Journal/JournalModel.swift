//
//  JournalModel.swift
//  Journal
//
//  Created by William Bundy on 8/13/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation
import CoreData

extension JournalEntry
{
	convenience init(_ title:String, _ text:String, _ moc:NSManagedObjectContext = CoreDataStack.shared.mainContext)
	{
		self.init(context: moc)
		self.title = title
		self.text = text
		self.timestamp = Date()
		self.identifier = UUID().uuidString
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

	init() {
		load()
	}

	var entries:[JournalEntry] = []
	var toRemove:[JournalEntry] = []
	var alwaysCleanImmediately:Bool = true
	var dirty:Bool = false {
		didSet {
			print("Dirty")
			if dirty {
				save()
			}
		}
	}


	func load()
	{
		if dirty {
			NSLog("Trying to reload data over unsaved changes!")
			return
		}

		let req:NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
		do {
			entries = try CoreDataStack.shared.mainContext.fetch(req)
		} catch {
			entries = []
			NSLog("Error fetching tasks \(error)")
		}
	}

	func save(withReset:Bool = true)
	{
		print("Saving")
		let moc = CoreDataStack.shared.mainContext
		for entry in toRemove {
			moc.delete(entry)
		}
		toRemove.removeAll()

		do { try moc.save() } catch {
			if withReset {
				moc.reset()
			}
			return
		}

		dirty = false
	}


	@discardableResult
	func create(_ title:String, _ text:String) -> JournalEntry
	{
		let e = JournalEntry(title, text)
		entries.append(e)
		dirty = true
		return e
	}

	func update(_ e:JournalEntry)
	{
		dirty = true
	}

	func delete(_ entry:JournalEntry)
	{
		guard let index = entries.index(of: entry) else {return}
		entries.remove(at: index)
		toRemove.append(entry)
		dirty = true
	}

}
