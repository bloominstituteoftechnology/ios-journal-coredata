//
//  DateExtensions.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

extension Date {
    var shortString: String {
        return DateFormatter.shortFormatter.string(from: self)
    }
}

extension DateFormatter {
    static var shortFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}
