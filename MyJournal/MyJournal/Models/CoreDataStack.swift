//
//  CoreDataStack.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
	
	static let shared = CoreDataStack()
	
	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "MyJournal")
		
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent stores(s): \(error)")
			}
		})
		
		return container
	}()
	
	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
}
