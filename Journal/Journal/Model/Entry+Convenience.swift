import Foundation
import CoreData

extension Entry {
    convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     identifier: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = Date()
        self.identifier = UUID().uuidString
    }
}
