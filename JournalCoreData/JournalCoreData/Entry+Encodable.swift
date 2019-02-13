//
//  Entry+Encodable.swift
//  JournalCoreData
//
//  Created by Angel Buenrostro on 2/13/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case mood
        case title
        case bodyText
        case timestamp
        case identifier
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mood, forKey: .mood)
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(identifier, forKey: .identifier)
    }
}
