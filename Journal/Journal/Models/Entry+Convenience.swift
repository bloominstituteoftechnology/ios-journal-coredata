//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Percy Ngan on 10/14/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

enum MoodStates: String {
	case 😞
	case 😕
	case 😆
}

extension Entry {

	@discardableResult convenience init(title: String,
										timestamp: Date = Date(),
										identifier: String = UUID().uuidString,
										bodyText: String, mood: MoodStates,
										context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

		self.init(context: context)

		self.title = title
		self.timestamp = timestamp
		self.identifier = identifier
		self.bodyText = bodyText
		self.mood = mood.rawValue
	}
}
