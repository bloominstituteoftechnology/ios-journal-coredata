//
//  Entry+CoreDataProperties.swift
//  
//
//  Created by Carolyn Lea on 8/21/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var bodyText: String?
    @NSManaged public var identifier: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?

}
