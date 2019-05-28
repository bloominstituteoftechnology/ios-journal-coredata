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
	
	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "JournalModel")
		container.loadPersistentStores(completionHandler: { _, error  in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		})
		return container
	}()
	
	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
	
}
