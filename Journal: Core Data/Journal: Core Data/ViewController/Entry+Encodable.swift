//
//  Entry+Encodable.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/24/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
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
        do {
            try container.encode(true, forKey: .title)
            try container.encode(true, forKey: .bodyText)
            try container.encode(true, forKey: .mood)
            try container.encode(true, forKey: .timestamp)
            try container.encode(true, forKey: .identifier)
        } catch {
            print("\nEntry+Encodeable.swift\nCould not encode keys")
        }
    }
}
