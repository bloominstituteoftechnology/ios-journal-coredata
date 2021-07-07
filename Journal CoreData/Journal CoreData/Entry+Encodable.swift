//
//  Entry+Encodable.swift
//  Journal CoreData
//
//  Created by Moin Uddin on 9/19/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
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
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.bodyText, forKey: .bodyText)
        try container.encode(self.mood, forKey: .mood)
        try container.encode(self.identifier, forKey: .identifier)
    }
}
