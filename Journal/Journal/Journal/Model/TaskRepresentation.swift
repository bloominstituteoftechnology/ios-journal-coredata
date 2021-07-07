//
//  TaskRepresentation.swift
//  Journal
//
//  Created by Taylor Lyles on 8/21/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {

	var bodyText: String?
	var identifier: String?
	var mood: String?
	var timestamp: Date?
	var title: String?

}

//var right: EntryRepresentation == var left: Entry

