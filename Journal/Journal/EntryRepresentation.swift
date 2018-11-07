//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/7/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import Foundation


func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
 return lhs.title == rhs.title &&
    lhs.bodytext == rhs.bodytext &&
    lhs.mood == rhs.mood &&
    lhs.timestamp == rhs.timestamp &&
    lhs.identifier == rhs.identifier
    
}

func == (lhs:Entry, rhs:EntryRepresentation) -> Bool {
    return rhs == lhs
    
}


func != (lhs:EntryRepresentation, rhs:Entry)-> Bool {
    return !(rhs == lhs)
    
}

func != (lhs:Entry, rhs:EntryRepresentation)-> Bool {
    return rhs != lhs
    
}

struct EntryRepresentation: Decodable, Equatable {
    
    var title: String
    var bodytext: String?
    var mood: String
    var timestamp: Date
    var identifier: String
    
    
    
    init(title: String, bodytext: String?, mood: String, timestamp: Date, identifier: String) {
        
        self.title = title
        self.bodytext = bodytext
        self.mood =  mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    
    
}
