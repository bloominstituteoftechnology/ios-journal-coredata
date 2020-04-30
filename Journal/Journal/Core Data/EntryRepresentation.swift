//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/29/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

struct EntryRepresentation: Codable {
    
    var bodyText: String
    var identifier: String
    var mood: String
    var timestamp: Date
    var title: String
    
}
