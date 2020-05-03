//
//  TimeStamper.swift
//  Journal
//
//  Created by Lambda_School_loaner_226 on 5/2/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation

class TimeStamper {
    static func formatter(for entry: Entry) -> String {
        return dateFormatter.string(from: entry.timeStamp!)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
}
