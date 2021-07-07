//
//  Entry+Encodable.swift
//  journal
//
//  Created by Lambda_School_Loaner_34 on 2/13/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
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
        //create variable container
        //set encoder parameter's container(keyedBy:...) pass CodingKeys.self to it
        var container = encoder.container(keyedBy: CodingKeys.self)
        //use container's encode(value: ..., for: ...) method to encode each of the the five attributes to the Entry individually
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(mood, forKey: .mood)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(identifier, forKey: .identifier)
    }
}
