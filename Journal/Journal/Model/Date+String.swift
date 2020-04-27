//
//  Date+String.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/22/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import Foundation
import CoreData

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    } 
}
