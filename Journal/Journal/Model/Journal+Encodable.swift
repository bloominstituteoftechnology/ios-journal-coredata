//
//  Journal+Encodable.swift
//  Journal
//
//  Created by Farhan on 9/19/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

extension Journal: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case notes
        case mood
        case timestamp
        case identifier
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.title, forKey: .title)
        try container.encode(self.notes, forKey: .notes)
        try container.encode(self.mood, forKey: .mood)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.identifier, forKey: .identifier)
        
    }
    
}
