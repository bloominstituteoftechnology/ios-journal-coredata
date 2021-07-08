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
	
	convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		
		self.init(title: entryRepresentation.title,
				  bodyText: entryRepresentation.bodyText,
				  identifier: entryRepresentation.identifier,
				  timeStamp: entryRepresentation.timeStamp,
				  mood: entryRepresentation.mood,
				  context: context)
	}
	
	var entryRepresentation: EntryRepresentation? {
		guard let identifier = identifier,
			let title = title,
			let mood = mood,
			let timeStamp = timeStamp
			else { return nil}

		return EntryRepresentation(identifier: identifier, title: title, mood: mood, bodyText: bodyText, timeStamp: timeStamp)
	}
	
}
