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
}

extension Entry {
	convenience init(title: String, bodyText: String, mood: Mood, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.title = title
		self.bodyText = bodyText
		self.timestamp = timestamp
		self.identifier = identifier
		self.mood = mood.rawValue
	}

	func getMood() -> Mood {
		return Mood(rawValue: mood) ?? .eh
	}
}
