//
//  JournalController.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

class JournalController {
	
	func createEntry(title: String, story: String?, entryFeeling: EntryEmoji) {
		Entry(title: title, story: story, lastUpdated: Date(), entryFeeling: entryFeeling)
		
		saveToPersistentStore()
	}
	
	func updateEntry(entry: Entry, title: String, story: String?, entryFeeling: EntryEmoji) {
		entry.title = title
		entry.story = story
		entry.lastUpdated = Date()
		entry.feelingEmoji = entryFeeling.rawValue
		
		saveToPersistentStore()
	}
	
	func delete(entry: Entry) {
		let moc = CoreDataStack.shared.mainContext
		
		moc.delete(entry)
		saveToPersistentStore()
		
	}
	
	func saveToPersistentStore() {
		let moc = CoreDataStack.shared.mainContext
		
		do {
			try moc.save()
		} catch {
			NSLog("Error saving moc: \(error)")
			moc.reset()
		}
	}
}
