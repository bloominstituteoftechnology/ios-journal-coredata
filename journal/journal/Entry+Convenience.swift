//  Copyright © 2019 Frulwinn. All rights reserved.

import CoreData
import UIKit

enum JournalMood: String {
    case 😫
    case 😐
    case 🤩
    
    static var allMoods: [JournalMood] {
        return [.😫, .😐, .🤩]
    }
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, mood: JournalMood = .😐,
                                        timestamp: Date = Date(), identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
}
