//
//  EntryRepresentation.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/16/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    
    let bodyText: String?
    let identifier: UUID
    let mood: EntryMood
    let timestamp: Date
    let title: String
}
