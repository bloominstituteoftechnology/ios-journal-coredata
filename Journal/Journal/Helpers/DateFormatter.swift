//
//  DateFormatter.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation


struct CustomDateFormatter {
    static func dateFormat (date: Date, format: String) -> String {
        let customDateFormatter = DateFormatter()
        customDateFormatter.dateFormat = format
        return customDateFormatter.string(from: date)
    }
}
