//
//  EntryRepresentation.swift
//  CoreDataJournal
//
//  Created by Marissa Gonzales on 5/20/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let bodyText: String
    let identifier: String
    let mood: String
    let timestamp: Date
    let title: String
}
