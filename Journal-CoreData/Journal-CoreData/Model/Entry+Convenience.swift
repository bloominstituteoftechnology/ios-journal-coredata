//
//  Entry+Convenience.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable, Codable {
	case happy = "😃"
	case neutral = "😐"
	case sad = "🙁"
}

extension Entry {
	@discardableResult convenience init(title: String,
										timeStamp: Date = Date(),
										identifier: UUID = UUID(),
										bodyText: String,
										context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
										mood: Mood) {

		self.init(context: context)
		self.title = title
		self.timeStamp = timeStamp
		self.identifier = identifier
		self.bodyText = bodyText
		self.mood = mood.rawValue
	}

	@discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		guard let title = entryRepresentation.title,
			let timeStamp = entryRepresentation.timeStamp,
			let identifier = entryRepresentation.identifier,
			let bodyText = entryRepresentation.bodyText,
			let moodStr = entryRepresentation.mood,
			let mood = Mood(rawValue: moodStr) else { return nil }

		self.init(title: title,
			  timeStamp: timeStamp,
			  identifier: identifier,
			  bodyText: bodyText,
			  context: context,
			  mood: mood)
	}

	var entryRepresentation: EntryRepresentation {
		return EntryRepresentation(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood)
	}
}
