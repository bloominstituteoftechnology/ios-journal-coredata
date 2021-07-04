//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    let title: String
    let bodyText: String
    let timestamp: Date
    let mood: String
    let identifier: UUID
    
}
