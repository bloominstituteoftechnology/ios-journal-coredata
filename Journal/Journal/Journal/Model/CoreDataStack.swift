//
//  CoreDataStack.swift
//  Journal
//
//  Created by Taylor Lyles on 8/19/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
	
	static let shared = CoreDataStack()
	
	lazy var container: NSPersistentContainer = {
		// Give the container the name of your data model file
		let container = NSPersistentContainer(name: "Tasks")
		
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		})
		
		return container
	}()
	
	// This should help you remember to use the viewContext on the main thread only
	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
}
