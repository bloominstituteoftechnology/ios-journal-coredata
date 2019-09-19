//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
	case happy
	case sad
	case neutral
}

extension Entry {

	var entryRepresentation: EntryRepresentation? {
		guard let

		return EntryRepresentation(title: <#T##String#>, bodyText: <#T##String#>, timestamp: <#T##Date#>, mood: <#T##String#>, identifier: <#T##String#>)
	}

	convenience init(title: String, bodyText: String, mood: Mood, context: NSManagedObjectContext) {

		self.init(context: context)

		self.title = title
		self.bodyText = bodyText
		self.timestamp = Date()
		self.identifier = "Entry\(Int.random(in: 1...5000))"
		self.mood = mood.rawValue
	}

	@discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
		guard let identifier = UUID(uuidString: entryRepresentation.identifier),
			let mood = EntryRepresentation(rawValue: entryRepresentation.mood) else { return nil }

		self.init(title: entryRepresentation.title,
				  bodyText: entryRepresentation.bodyText,
				  mood: mood,
				  identifier: identifier,
				  timestamp: entryRepresentation.timestamp)
	}
}
