//
//  Entry+Encodable.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/15/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import Foundation


extension Entry: Encodable {
    
    
    enum CodingKeys: String, CodingKey {
        case title
        case bodyText
        case timestamp
        case mood
        case identifier
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(mood, forKey: .mood)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
}
