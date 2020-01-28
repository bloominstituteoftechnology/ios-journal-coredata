//
//  TimestampFormatter.swift
//  JournalCoreData
//
//  Created by Spencer Curtis on 8/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
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
