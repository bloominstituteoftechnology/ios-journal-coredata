//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Sean Hendrix on 11/7/18.
//  Copyright © 2018 Sean Hendrix. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    
    var title: String
    var bodyText: String?
    var timestamp: Date
    var mood: String
    var identifier: String
    
    init(title: String, bodyText: String?, mood: String, timestamp: Date, identifier: String) {
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
}
