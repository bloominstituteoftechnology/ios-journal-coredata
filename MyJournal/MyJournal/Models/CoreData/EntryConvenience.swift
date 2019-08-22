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
	
	@discardableResult convenience init(id: UUID = UUID(), title: String, story: String?, lastUpdated: Date = Date(), mood: MoodEmoji,
										context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		
		self.title = title
		self.story = story
		self.lastUpdated = lastUpdated
		self.mood = mood.rawValue
		self.id = id
	}
	
	//EntryRepresentation -> Task
	
	convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		guard let id = entryRepresentation.id,
			let title = entryRepresentation.title,
			let moodString = entryRepresentation.mood,
			let lastUpdated = entryRepresentation.timestamp,
			let mood = MoodEmoji(rawValue: moodString) else { return nil }
		
		self.init(id: id, title: title, story: entryRepresentation.bodyText, lastUpdated: lastUpdated, mood: mood, context: context)
	}
	
	//Task -> EntryRepresentation
	
	var entryRepresentation: EntryRepresentation {
		return EntryRepresentation(id: id, title: title, bodyText: story, mood: mood, timestamp: lastUpdated)
	}
}
