//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Christopher Aronson on 5/29/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
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

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(mood, forKey: .mood)
        try container.encode(identifier, forKey: .identifier)
    }

}
