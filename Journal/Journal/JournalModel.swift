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
