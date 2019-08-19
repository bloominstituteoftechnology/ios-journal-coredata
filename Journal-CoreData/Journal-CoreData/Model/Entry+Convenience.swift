//
//  Entry+Convenience.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData


extension Entry {
	@discardableResult convenience init(title: String, timeStamp: Date = Date(), identifier: String, bodyText: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

		self.init(context: context)
		self.title = title
		self.timeStamp = timeStamp
		self.identifier = identifier
		self.bodyText = bodyText
	}
}
