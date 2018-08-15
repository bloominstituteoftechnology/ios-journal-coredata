//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Andrew Liao on 8/15/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation

enum CodingKeys: String, CodingKey {
    case title
    case bodyText
    case mood
    case identifier
    case timeStamp
    
    
}
extension Entry: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(mood, forKey: .mood)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(timeStamp, forKey: .timeStamp)
    }
}
