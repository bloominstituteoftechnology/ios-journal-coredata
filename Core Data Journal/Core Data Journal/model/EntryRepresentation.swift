//
//  EntryRepresentation.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
	let bodyText: String?
	let identifier: String
	let mood: Int16
	let timestamp: Date
	let title: String
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
	return lhs.identifier == rhs.identifier &&
			lhs.bodyText == rhs.bodyText &&
			lhs.mood == rhs.mood &&
			lhs.timestamp == rhs.timestamp &&
			lhs.title == lhs.title
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
	return rhs == lhs
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
	return !(lhs == rhs)
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
	return rhs != lhs
}
