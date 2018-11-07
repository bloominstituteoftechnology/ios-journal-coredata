//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/7/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import CoreData

extension Entry: Encodable {
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        
        try container.encode(title, forKey: .title)
        try container.encode(bodytext, forKey: .bodytext)
        try container.encode(mood, forKey: .mood)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(identifier, forKey: .identifier)
        
        
        
        
        
    }
    
    
    
}




enum CodingKeys: String, CodingKey {
  case title
  case bodytext
  case mood
  case timestamp
  case identifier
    
    
    
}
