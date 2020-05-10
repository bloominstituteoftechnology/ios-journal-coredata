//  Copyright © 2019 Frulwinn. All rights reserved.

import CoreData
import UIKit

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String,
                     timestamp: Date = Date(), identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
}
