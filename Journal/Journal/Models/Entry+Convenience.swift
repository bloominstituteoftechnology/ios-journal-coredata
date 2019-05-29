//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Hector Steven on 5/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation
import CoreData


extension Entry {
	convenience init (title: String, bodyText: String? = nil,
					  identifier: String = UUID().uuidString,
					  timeStamp: Date = Date(),
					  mood: String,
					  context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		
		self.init(context: context)
		self.title = title
		self.bodyText = bodyText
		self.identifier = identifier
		self.timeStamp = timeStamp
		self.mood = mood
	}
}
