//
//  EntryConvenience.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
	
	@discardableResult convenience init(title: String, story: String?, lastUpdated: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		
		self.title = title
		self.story = story
		self.lastUpdated = lastUpdated
	}
}
