//
//  Entry+Encodable.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/13/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Encode each of the 5 attributes of the Entry individually
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mood, forKey: .mood)
    }
 
    enum CodingKeys: String, CodingKey {
        case title
        case bodyText
        case timestamp
        case identifier
        case mood
    }
}
