//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {

	convenience init(title: String, bodyText: String, timestamp: Date, identifier: String, context: NSManagedObjectContext) {

		self.init(context: context)

		self.title = title
		self.bodyText = bodyText
		self.timestamp = timestamp
		self.identifier = identifier
	}
}
