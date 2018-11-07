//
//  Entry+Convenience.swift
//  Journal-CoreData
//
//  Created by Nikita Thomas on 11/5/18.
//  Copyright © 2018 Nikita Thomas. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String,
                     bodyText: String,
                     timeStamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     mood: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood
    }
}

extension Entry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case title, timeStamp, mood, identifier, bodyText
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: CodingKeys.title)
        try container.encode(timeStamp, forKey: CodingKeys.timeStamp)
        try container.encode(mood, forKey: CodingKeys.mood)
        try container.encode(identifier, forKey: CodingKeys.identifier)
        try container.encode(bodyText, forKey: CodingKeys.bodyText)
        
    }
}
