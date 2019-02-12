//  Copyright © 2019 Frulwinn. All rights reserved.

import CoreData
import UIKit

enum JournalMood: String {
    case sad = "😫"
    case meh = "😐"
    case happy = "🤩"
    
    static var allMoods: [JournalMood] {
        return [.sad, .meh, .happy]
    }
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, mood: JournalMood = .meh,
                                        timestamp: Date = Date(), identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
}
