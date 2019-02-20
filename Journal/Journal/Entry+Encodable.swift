//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/20/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case bodyText
        case timestamp
        case identifier
        case mood
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.bodyText, forKey: .bodyText)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.mood, forKey: .mood)
    }
    
}
