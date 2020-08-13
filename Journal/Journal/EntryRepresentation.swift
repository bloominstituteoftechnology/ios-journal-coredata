//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Dojo on 8/12/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

struct EntryRepresentation: Codable {
    
    var identifier: String
    var title: String
    var bodyText: String
    var mood: String
    var timestamp: Date
    
}
