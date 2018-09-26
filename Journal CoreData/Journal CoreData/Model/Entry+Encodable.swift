//
//  Entry+Encodable.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/26/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(bodyText, forKey: .bodyText)
        try container.encode(mood, forKey: .mood)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(identifier, forKey: .identifier)
    }
    
    enum CodingKeys: CodingKey {
        case title
        case bodyText
        case mood
        case timestamp
        case identifier
    }
}
