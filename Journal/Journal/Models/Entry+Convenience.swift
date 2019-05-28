//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

extension Entry {

    convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)

        self.title = title
        self.bodyText = bodyText
        self.timestamp = getTimestampString(from: timestamp)
        self.identifier = identifier

    }

    private func getTimestampString(from date: Date) -> String {

        let calandar = Calendar.current

        let hour = calandar.component(.hour, from: date)
        let minute = calandar.component(.minute, from: date)

        let month = calandar.component(.month, from: date)
        let day = calandar.component(.day, from: date)
        let year = calandar.component(.year, from: date)

        return "\(month)/\(day)/\(year) \(hour):\(minute)"
    }
}
