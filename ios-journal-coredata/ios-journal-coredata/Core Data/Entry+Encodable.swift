//
//  Entry+Encodable.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/15/18.
//  Copyright © 2018 Conner. All rights reserved.
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
