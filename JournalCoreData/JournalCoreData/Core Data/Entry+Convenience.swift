import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timeStamp: Date = Date(), identifier: String, mood: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.bodyText = bodyText
        self.title = title
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood
        
    }
    
    convenience init(entryRepresentation: EntryRepresentation, moc: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
       
        self.init(title: entryRepresentation.title!, bodyText: entryRepresentation.bodyText!, timeStamp: entryRepresentation.timeStamp!, identifier: entryRepresentation.identifier!, mood: entryRepresentation.mood!, context: moc)
    }
}
