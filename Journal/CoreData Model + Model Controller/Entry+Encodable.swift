//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Jason Modisett on 9/19/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case bodyText
        case identifier
        case mood
        case timestamp
        case title
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.title, forKey: .title)
        try container.encode(self.bodyText, forKey: .bodyText)
        try container.encode(self.mood, forKey: .mood)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.identifier, forKey: .identifier)
    }
}
