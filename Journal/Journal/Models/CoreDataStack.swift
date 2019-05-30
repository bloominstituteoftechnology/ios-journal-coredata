//
//  CoreDataStack.swift
//  Journal
//
//  Created by Hector Steven on 5/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
	static let shared = CoreDataStack()
	
	/// A generic function to save any context we want (main or background)
	func save(context: NSManagedObjectContext) throws {
		var error: Error?
		
		context.performAndWait {
			do {
				try context.save()
			} catch let saveError {
				NSLog("Error saving moc: \(saveError)")
				error = saveError
			}
		}
		
		if let error = error {
			throw error
		}
	}
	
	
	lazy var container: NSPersistentContainer = {
		
		let container = NSPersistentContainer(name: "JournalModel")
		
		container.loadPersistentStores { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		}
		
		container.viewContext.automaticallyMergesChangesFromParent = true
		
		return container
	}()
	
	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
	
}
