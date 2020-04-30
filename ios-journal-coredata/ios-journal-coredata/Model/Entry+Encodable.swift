//
//  Entry+Encodable.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 15.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
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
        try container.encode(title, forKey: CodingKeys.title)
        try container.encode(bodyText, forKey: CodingKeys.bodyText)
        try container.encode(mood, forKey: CodingKeys.mood)
        try container.encode(timestamp, forKey: CodingKeys.timestamp)
        try container.encode(identifier, forKey: CodingKeys.identifier)
    }
    
}
