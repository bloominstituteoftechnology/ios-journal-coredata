//
//  TimestampFormatter.swift
//  Journal
//
//  Created by macbook on 10/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class TimestampFormatter {
    
    static func formatTimestamp(for entry: Entry) -> String {
        return dateFormatter.string(from: entry.timestamp!)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
}
