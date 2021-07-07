import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timeStamp: Date = Date(), identifier: String, mood: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.bodyText = bodyText
        self.title = title
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood
        
    }
    //Entry from representation
    convenience init(entryRepresentation: EntryRepresentation, moc: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
       
        self.init(title: entryRepresentation.title!, bodyText: entryRepresentation.bodyText!, timeStamp: entryRepresentation.timeStamp!, identifier: entryRepresentation.identifier!, mood: entryRepresentation.mood!, context: moc)
    }
    //Representation from Entry
    var entryRepresentation: EntryRepresentation? {
        guard let title = title else { return nil }
        
        var entryID: UUID! = UUID(uuidString: identifier!)
        if identifier == nil {
            entryID = UUID()
            identifier = entryID.uuidString
        }
        return EntryRepresentation(bodyText: bodyText, identifier: identifier, mood: mood, timeStamp: timeStamp, title: title)
    }
}
