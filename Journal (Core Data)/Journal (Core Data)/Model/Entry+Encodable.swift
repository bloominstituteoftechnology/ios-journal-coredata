//
//  Entry+Encodable.swift
//  Journal (Core Data)
//
//  Created by Simon Elhoej Steinmejer on 15/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

extension Entry: Encodable
{
    enum CodingKeys: String, CodingKey
    {
        case title = "title"
        case bodyText = "bodyText"
        case identifier = "identifier"
        case mood = "mood"
        case timestamp = "timestamp"
    }
    
    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mood, forKey: .mood)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
