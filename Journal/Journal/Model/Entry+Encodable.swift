//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Jeremy Taylor on 8/15/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case timestamp
        case mood
        case identifier
        case bodyText
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(mood, forKey: .mood)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(bodyText, forKey: .bodyText)
    }
}
