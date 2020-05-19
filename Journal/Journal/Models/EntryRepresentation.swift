//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Kelson Hartle on 5/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable {
    
    var bodyText: String
    var identifier: String
    var mood: String
    var timeStamp: Date
    var title: String
    
}
