//
//  Entry+Encodable.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/19/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case bodyText
        case mood
        case timestamp
        case identifier
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.bodyText, forKey: .bodyText)
        try container.encodeIfPresent(self.mood, forKey: .mood)
        try container.encodeIfPresent(self.timestamp, forKey: .timestamp)
        try container.encodeIfPresent(self.identifier, forKey: .identifier)
    }
}
