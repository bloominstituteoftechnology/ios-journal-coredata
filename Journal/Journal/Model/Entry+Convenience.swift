//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Daniela Parra on 9/17/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case bad = "🙄"
    case good = "🙂"
    case great = "😍"
    
    static var allMoods: [Mood] {
        return [.bad, .good, .great]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    var timestampString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        return dateFormatter.string(from: timestamp ?? Date())
    }
}
