//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-13.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

protocol Representable {
    associatedtype Representation: Codable
    var representation: Representation? { get }
}

extension Entry: Representable {
    struct Representation: Codable {
        var title: String
        var bodyText: String
        var mood: String
        var timestamp: Date
        var identifier: String
    }
    
    var representation: Representation? {
        guard let title = self.title,
            let body = self.bodyText,
            let mood = self.mood,
            let timestamp = self.timestamp,
            let id = self.identifier
            else {
                print("Error generating entry representation for entry; one of the required properties is nil!")
                return nil
        }
        return Representation(
            title: title,
            bodyText: body,
            mood: mood,
            timestamp: timestamp,
            identifier: id)
    }
    
    // MARK: - Convenience Init
    
    @discardableResult convenience init?(
        representation: Representation,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.title = representation.title
        self.bodyText = representation.bodyText
        self.mood = representation.mood
        self.timestamp = representation.timestamp
        self.identifier = representation.identifier
    }
}

// MARK: - Equatable

extension Entry.Representation: Equatable {
    static func == (lhs: Entry.Representation, rhs: Entry.Representation) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
