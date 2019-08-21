//
//  EntryRepresentation.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable {
	let title: String?
	let bodyText: String?
	let timeStamp: Date?
	let identifier: String?
	let mood: String?
}


func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
	return lhs.title == rhs.title &&
		lhs.bodyText == rhs.bodyText &&
		lhs.timeStamp == rhs.timeStamp &&
		lhs.mood == rhs.mood &&
		lhs.identifier == rhs.identifier
}

func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool {
	return rhs == lhs
}

func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
	return !(lhs == rhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
	return rhs != lhs
}
