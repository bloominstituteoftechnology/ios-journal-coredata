//
//  Entry+Encodable.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/13/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation

enum CodingKeys: CodingKey {
    
    case title
    case bodyText
    case identifier
    case mood
    case timestamp
    
}
extension Entry: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mood, forKey: .mood)
        try container.encode(timestamp, forKey: .timestamp)
        
    }
    
    
}
