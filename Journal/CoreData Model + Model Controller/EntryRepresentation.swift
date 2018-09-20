//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jason Modisett on 9/19/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    
    var bodyText: String?
    var identifier: String
    var mood: String
    var timestamp: Date
    var title: String
    
    init(title: String, bodyText: String?, mood: String, timestamp: Date, identifier: String) {
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
}


