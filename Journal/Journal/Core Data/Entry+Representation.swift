//
//  Entry+Representation.swift
//  Journal
//
//  Created by Joseph Rogers on 2/26/20.
//  Copyright © 2020 Moka Apps. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var bodyText: String?
    var identifier: String?
    var mood: String
    var timestamp: Date?
    var title: String
    
}
