//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Percy Ngan on 9/18/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {

	let title: String
	let bodyText: String
	let timestamp: Date
	let mood: String
	let identifier: String

static func 

}

//static func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
//
//	return lhs.identifier == rhs.identifier &&
//
//}
//
//func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
//
//	return rhs == lhs
//}
//
//func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
//
//	return !(rhs == lhs)
//}
//
//func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
//
//	return rhs != lhs
//}
