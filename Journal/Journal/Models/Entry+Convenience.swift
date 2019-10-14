//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Percy Ngan on 10/14/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {

	convenience init(title: String, timestamp: Date = Date(), identifier: String, bodyText: String, context: NSManagedObjectContext) {

		self.init(context: context)

		self.title = title
		self.timestamp = timestamp
		self.identifier = identifier
		self.bodyText = bodyText
	}
}
