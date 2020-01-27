//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Tobi Kuyoro on 27/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timeStamp: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
    }
}
