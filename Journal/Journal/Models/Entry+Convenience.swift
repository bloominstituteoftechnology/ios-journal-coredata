//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
	case happy
	case sad
	case neutral
}

extension Entry {

	convenience init(title: String, bodyText: String, mood: Mood, context: NSManagedObjectContext) {

		self.init(context: context)

		self.title = title
		self.bodyText = bodyText
		self.timestamp = Date()
		self.identifier = "Entry\(Int.random(in: 1...5000))"
		self.mood = mood.rawValue

		
	}
}
