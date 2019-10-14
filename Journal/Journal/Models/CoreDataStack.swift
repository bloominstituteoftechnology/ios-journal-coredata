//
//  CoreDataStack.swift
//  Journal
//
//  Created by Percy Ngan on 10/14/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

// This file sets up
// This kind of acts like a controller
class CoreDataStack {

	// shared property pattern
	// Let us access the CoreDataStack from anywhere inthe app
	static let shared = CoreDataStack()

	// Setup a persistent container

	lazy var container: NSPersistentContainer = {

		let container = NSPersistentContainer(name: "Journal") // Name of the data model file
		// creates a persistent store
		container.loadPersistentStores { (_, error) in
			// Check for an error and intentionally crash the app with fatalError if there is an error
			if let error = error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		}
		// Return the container
		return container
	}()


	// Create easy acces to the ManagedObjectContext (moc)
	// Create a computed property
	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}

	func saveToPersistentStore() {
		do {
			try mainContext.save()
		} catch {
			NSLog("Error saving context: \(error)")
			// resets the main context if there is an error
			mainContext.reset()
		}
	}
}
