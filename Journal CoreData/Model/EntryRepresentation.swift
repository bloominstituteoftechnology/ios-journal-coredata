//
//  EntryRepresentation.swift
//  Journal CoreData
//
//  Created by Andrew Ruiz on 9/18/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import Foundation

// The TaskRepresentation is an exact copy of the Entry object in the data model, without its Core Data aspects.

struct EntryRepresentation: Codable {
    
    let bodyText: String
    let identifier: String
    let mood: String
    let timestamp: Date
    let title: String
}
