//
//  Entry+Encoder.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/22/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import Foundation

import Foundation
extension Entry: Encodable {
    enum CodingKeys: String, CodingKey {
        case name
        case timestamp
        case mood
        case identifier
        case bodyText
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(mood, forKey: .mood)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(bodyText, forKey: .bodyText)
    }
}
