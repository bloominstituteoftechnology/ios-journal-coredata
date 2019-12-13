//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Alex Thompson on 12/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    var bodyTitle: String?
    var identifier: String?
    var mood: String
    var timestamp: Date
    var title: String
    
}
