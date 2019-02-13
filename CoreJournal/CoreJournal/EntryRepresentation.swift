//
//  EntryRepresentation.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/13/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation

struct EntryRepresentation: Encodable, Equatable {
    
    var title: String
    var bodyText: String
    var identifier: String
    var timestamp: Date
    var mood: String
    
}
