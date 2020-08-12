//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Cora Jacobson on 8/11/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    var identifier: String
    var title: String
    var bodyText: String
    var mood: String
    var timestamp: Date
    
}
