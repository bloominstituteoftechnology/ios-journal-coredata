import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timeStamp: Date = Date(), identifier: String = "", mood: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.bodyText = bodyText
        self.title = title
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood
        
    }
}
