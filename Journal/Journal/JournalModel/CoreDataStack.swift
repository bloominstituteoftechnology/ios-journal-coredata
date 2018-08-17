
import Foundation
import UIKit
import CoreData

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

		con.viewContext.automaticallyMergesChangesFromParent = true

		return con
	}()

	var mainContext:NSManagedObjectContext { return container.viewContext }

	static func save(_ moc:NSManagedObjectContext, withReset:Bool = true)
	{
		moc.perform {
			do {
				try moc.save()
			} catch {
				App.logError(EmptyHandler, "Failed to save moc: \(error)")
				if withReset {
					moc.reset()
				}
			}
		}
	}
}
