//
//  CoreDataStack.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

	static let shared = CoreDataStack()

	private init() {

	}

	lazy var container: NSPersistentContainer = {

		// give it the file name of the data model file name
		let container = NSPersistentContainer(name: "Journal")
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		})

		return container
	}()

	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}

	func saveToPersistentStore() {
		do {
			try mainContext.save()
		} catch {
			NSLog("Error saving context: \(error)")
			mainContext.reset()
		}
	}

}


