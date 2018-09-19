//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Daniela Parra on 9/19/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case bodyText
        case timestamp
        case identifier
        case mood
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.encode(String.self, forKey: .title)
        self.bodyText = try container.encode(String.self, forKey: .bodyText)
        self.timestamp = try container.encode(Date.self, forKey: .timestamp)
        self.identifier = try container.encode(String.self, forKey: .identifier)
        self.mood = try container.encode(String.self, forKey: .mood)
        
    }
    
    
}
