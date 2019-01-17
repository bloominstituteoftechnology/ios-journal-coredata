//
//  Entry+Encodable.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/16/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mood, forKey: .mood)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(title, forKey: .title)
    }
    
    enum CodingKeys: String, CodingKey {
        case bodyText
        case identifier
        case mood
        case timestamp
        case title
    }
    
}
