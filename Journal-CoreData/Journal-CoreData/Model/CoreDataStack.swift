//
//  CoreDataStack.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

	private init() {}
	static let shared = CoreDataStack()

	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Entry")
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent store(s): \(error)")
			}
		})
		return container
	}()

	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
}
