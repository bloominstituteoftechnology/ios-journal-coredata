//
//  Utility.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class Utility {
    /**
     returns a String from the date passed in formatted with a .short dateStyle and timeStyle
     */
    class func formattedDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df.string(from: date)
    }
}

