//
//  Date+String.swift
//  Journal
//
//  Created by Matthew Martindale on 4/22/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
