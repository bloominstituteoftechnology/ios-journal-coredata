//
//  EntryRepresentation.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/21/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
	var id: UUID?
	var title: String?
	var bodyText: String?
	var mood: String?
	var timestamp: Date?
}
