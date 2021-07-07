//
//  DateFormatter.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/24/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
struct DateFormat {
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    let timestamp: Date = Date()
}
