import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case 😔, 😐, 😃
}

extension Entry {
    convenience init(title: String,
                     bodyText: String,
                     mood: String,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
