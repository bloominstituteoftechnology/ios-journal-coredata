//
//  Entry+CoreDataProperties.swift
//  Journal
//
//  Created by Shawn Gee on 3/25/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var bodyText: String?
    @NSManaged public var identifier: String
    @NSManaged public var moodString: String
    @NSManaged public var timestamp: Date
    @NSManaged public var title: String

}
