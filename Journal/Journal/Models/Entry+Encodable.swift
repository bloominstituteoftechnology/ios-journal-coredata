//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Scott Bennett on 9/26/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation
import CoreData

enum CodingKeys: String, CodingKey {
    case title
    case bodyText
    case mood
    case timestamp
    case identifier
}

extension Entry: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(mood, forKey: .mood)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(identifier, forKey: .identifier)
        
    }


}


