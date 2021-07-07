//
//  Entry+Convenience.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import CoreData

enum Mood: Int16, CaseIterable  {
	case poop
	case moneyWithWings
	case eggplant
	case wave
	case eh
	case mermaid
	case cherries

	var stringValue: String {
		switch self {
		case .poop:
			return "💩"
		case .moneyWithWings:
			return "💸"
		case .eggplant:
			return "🍆"
		case .wave:
			return "👋"
		case .eh:
			return "🤙"
		case .mermaid:
			return "🧜🏾‍♀️"
		case .cherries:
			return "🍒"
		}
	}
}

extension Entry {
	convenience init(title: String, bodyText: String?, mood: Mood, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.title = title
		self.bodyText = bodyText
		self.timestamp = timestamp
		self.identifier = identifier
		self.mood = mood.rawValue
	}

	convenience init(representation: EntryRepresentation, context: NSManagedObjectContext) {
		let mood = Mood(rawValue: representation.mood) ?? Mood.eh
		self.init(title: representation.title, bodyText: representation.bodyText, mood: mood, timestamp: representation.timestamp, identifier: representation.identifier, context: context)
	}

	func getMood() -> Mood {
		return Mood(rawValue: mood) ?? .eh
	}

	var entryRepresentation: EntryRepresentation? {
		guard let identifier = identifier, let timestamp = timestamp, let title = title else { return nil }
		return EntryRepresentation(bodyText: bodyText, identifier: identifier, mood: mood, timestamp: timestamp, title: title)
	}

	var threadSafeID: String? {
		get {
			guard let context = self.managedObjectContext else { return nil }
			var id: String?
			context.performAndWait {
				id = self.identifier
			}
			return id
		}

		set {
			guard let context = self.managedObjectContext else { return }
			context.performAndWait {
				self.identifier = newValue
			}
		}
	}
}
