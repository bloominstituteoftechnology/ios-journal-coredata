//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/29/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    
    var bodyText: String?
    var identifier: String
    var mood: String
    var timestamp: Date
    var title: String
    
}
